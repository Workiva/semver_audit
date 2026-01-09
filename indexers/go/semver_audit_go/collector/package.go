package collector

import (
	"encoding/json"
	"go/ast"
	"go/token"
	"log"
	"reflect"
	"strconv"

	"fmt"
	"io/ioutil"
	"os"
	"strings"

	"github.com/Workiva/semver-audit/indexers/go/semver_audit_go/payloads"
	"github.com/fatih/structtag"
)

// PackageCollector implements the ast.Visitor interface and also
// provides a convenient API for use with an AST package object.
// Its purpose is to scan an entire package and recover a set of
// export payloads that can then be submitted to the semver audit
// service.
type PackageCollector struct {
	Debug bool
	// exports is a map from export key to the exports themselves,
	// the keys are duplicated in this way because that's what the
	// semver service requires.
	exports  map[string]payloads.Export
	filePath string
	fileSet  *token.FileSet
	fileText []byte
	lastType string
	pkgBase  string
	pkgName  string
}

// NewPackageVisitor creates a new package visitor using the given
// file set, which should correspond to any AST nodes that are later
// passed into the "Search" method or visited by the instance directly.
func NewPackageVisitor(fileSet *token.FileSet) *PackageCollector {
	return &PackageCollector{
		exports: map[string]payloads.Export{},
		fileSet: fileSet,
	}
}

// Exports returns a map of the exports provided by any packages that
// were scanned using the "Search" method (or by using the instance
// as a visior directly. The map keys are just the "key" field for
// each export.
func (p *PackageCollector) Exports() map[string]payloads.Export {
	return p.exports
}

// Search is the primary entry point for using this struct to find semver
// information. The provided package will be scanned and data about its
// exports will be collected.
func (p *PackageCollector) Search(pkg *ast.Package) {
	ast.Walk(p, pkg)
}

// Visit implements the ast.Visitor interface, though it is recommended
// to use the Search method instead for simplicity.
func (p *PackageCollector) Visit(node ast.Node) ast.Visitor {
	switch typedNode := node.(type) {
	case *ast.Field:
		return p.handleField(typedNode)
	case *ast.File:
		return p.handleFile(typedNode)
	case *ast.FuncDecl:
		return p.handleFuncAndMethod(typedNode)
	case *ast.GenDecl:
		if typedNode.Tok == token.CONST {
			return p.handleVarAndConst(typedNode, true)
		}
		if typedNode.Tok == token.VAR {
			return p.handleVarAndConst(typedNode, false)
		}
	case *ast.Package:
		return p.handlePackage(typedNode)
	case *ast.TypeSpec:
		return p.handleType(typedNode)
	}

	return p
}

func (p *PackageCollector) currentPkg() string {
	if p.pkgBase == "" {
		return p.pkgName
	}
	return p.pkgBase + "/" + p.pkgName
}

// TODO: DOCPLAT-3361 - don't include package name twice
func (p *PackageCollector) currentURI() string {
	return p.currentPkg() + "/" + p.filePath
}

// getReceiver returns the receiver type for the given method as
// a string. If the provided argument does not represent a method
// then the empty string is returned.
//
// For example, the following declaration would result in "A":
//
//	func (a *A) Foo() { ... }
func (p *PackageCollector) getReceiver(decl *ast.FuncDecl) string {
	if decl.Recv == nil {
		return ""
	}

	var typeNode ast.Node
	typeNode = decl.Recv.List[0].Type

	// Remove pointer.
	if t, ok := typeNode.(*ast.StarExpr); ok {
		typeNode = t.X
	}

	// If the receiver is a generic we don't want to include the brackets in the receiver name.
	// First, because it's not a breaking change to alter the name of a generic type parameter.
	// Second, because the [T] won't appear in the name of the struct in PackageCollector's exports.
	if t, ok := typeNode.(*ast.IndexExpr); ok {
		typeNode = t.X
	}

	start := p.fileSet.Position(typeNode.Pos()).Offset
	end := p.fileSet.Position(typeNode.End()).Offset
	return string(p.fileText[start:end])
}

func (p *PackageCollector) handleField(field *ast.Field) ast.Visitor {
	for _, ident := range field.Names {
		if !ident.IsExported() {
			continue
		}

		typeString := p.nodeToString(field.Type)

		tags := make(map[string][]string)

		if field.Tag != nil {
			unquotedTag, _ := strconv.Unquote(field.Tag.Value)
			parsedTags, err := structtag.Parse(unquotedTag)
			if err != nil {
				fmt.Fprintf(os.Stderr, "Field (%s) contained an unparsable struct tag, skipping. (%s)\n", ident.Name, field.Tag.Value)
			} else {
				for _, tag := range parsedTags.Tags() {
					tags[tag.Key] = []string{tag.Name}
					tags[tag.Key] = append(tags[tag.Key], tag.Options...)
				}
			}
		}

		grammar := &payloads.Field{
			Name:      ident.Name,
			Signature: ident.Name + " " + typeString,
			Type:      typeString,
			Tags:      tags,
		}

		if _, ok := field.Type.(*ast.FuncType); ok {
			grammar.IsAbstract = true
		}

		p.newExport(grammar, ident.Pos())
	}

	return nil
}

func (p *PackageCollector) handleFile(file *ast.File) ast.Visitor {
	tokenFile := p.fileSet.File(file.Pos())
	p.filePath = tokenFile.Name()
	fileText, err := ioutil.ReadFile(p.filePath)
	if err != nil {
		panic(err)
	}
	p.fileText = fileText
	return p
}

func (p *PackageCollector) handleFuncAndMethod(decl *ast.FuncDecl) ast.Visitor {
	if !decl.Name.IsExported() {
		return nil
	}

	var grammar payloads.FunctionOrMethod
	if decl.Recv == nil {
		grammar = payloads.NewFunction()
	} else {
		receiver := p.getReceiver(decl)
		if !ast.IsExported(receiver) {
			// We bail if the receiver isn't exported to avoid including
			// public methods of private structs.
			return nil
		}
		grammar = payloads.NewMethod(receiver)
	}

	signature := "func"

	// Receiver
	if decl.Recv != nil {
		signature += " " + p.nodeToString(decl.Recv)
	}

	// Name
	grammar.SetName(decl.Name.Name)
	signature += " " + decl.Name.Name + "("

	// Parameters
	params := []string{}
	if decl.Type.Params != nil {
		for _, field := range decl.Type.Params.List {
			for _, ident := range field.Names {
				typeString := p.nodeToString(field.Type)

				params = append(params, ident.Name+" "+typeString)

				p := payloads.Parameter{
					Name:     ident.Name,
					Type:     typeString,
					Required: true,
				}
				grammar.AddPositionalParameter(p)
			}
		}
	}

	signature += strings.Join(params, ", ") + ")"

	// Return types
	returnTypes := []string{}
	if decl.Type.Results != nil {
		for _, a := range decl.Type.Results.List {
			returnTypes = append(returnTypes, p.nodeToString(a))
		}
	}
	returnString := ""
	if len(returnTypes) > 0 {
		returnString = strings.Join(returnTypes, ", ")
		if len(returnTypes) > 1 {
			returnString = "(" + returnString + ")"
		}
	}
	if returnString != "" {
		grammar.SetReturnType(returnString)
		signature += " " + returnString
	}

	grammar.SetSignature(signature)
	p.newExport(grammar, decl.Pos())

	return nil
}

func (p *PackageCollector) handlePackage(pkg *ast.Package) ast.Visitor {
	p.pkgName = pkg.Name
	p.newExport(nil, pkg.Pos())
	return p
}

func (p *PackageCollector) handleType(spec *ast.TypeSpec) ast.Visitor {
	ident := spec.Name

	if !ident.IsExported() {
		// If the type is not exported then we ignore all its fields since
		// they should be kept internal to the package and the tooling will
		// warn in cases where they might be exposed.
		return nil
	}

	p.lastType = ident.Name

	grammar := payloads.NewClass(ident.Name)
	grammar.Signature = "type " + getExprStringFromFileSet(p.fileSet, spec)

	if _, ok := spec.Type.(*ast.InterfaceType); ok {
		grammar.IsAbstract = true
	}

	p.newExport(grammar, spec.Pos())

	return p
}

func (p *PackageCollector) handleVarAndConst(decl *ast.GenDecl, constant bool) ast.Visitor {
	for _, spec := range decl.Specs {
		valueSpec, ok := spec.(*ast.ValueSpec)
		if !ok {
			continue
		}

		signature := getExprStringFromFileSet(p.fileSet, valueSpec)

		for i, ident := range valueSpec.Names {
			if !ident.IsExported() {
				continue
			}

			// We want to avoid running the type checker because it interacts
			// awkwardly with GopherJS code. We can find types just fine in
			// most cases, but when an exported variable is type-inferred we
			// don't have type information. Instead, we try to guess based on
			// the literal assigned to the variable (if there is one) and
			// fall back to warning that we couldn't determine the type and
			// using a dummy value for the type.
			var typeString string
			if valueSpec.Type == nil {
				if valueSpec.Values != nil {
					// Attempt to infer from the literal, if any
					value := valueSpec.Values[i]
					switch typedValue := value.(type) {
					case *ast.BasicLit:
						switch typedValue.Kind {
						case token.CHAR:
							typeString = "char"
						case token.FLOAT:
							typeString = "float"
						case token.IMAG:
							typeString = "complex"
						case token.INT:
							typeString = "int"
						case token.STRING:
							typeString = "string"
						}
					}
				}
			} else {
				typeString = p.nodeToString(valueSpec.Type)
			}

			if typeString == "" {
				start := p.fileSet.Position(ident.Pos())
				fmt.Fprintf(os.Stderr, "Warning: could not determine type of variable at %s\n", start.String())
				typeString = "unknown"
			}

			var prefix string
			if constant {
				prefix = "const"
			} else {
				prefix = "var"
			}

			grammar := &payloads.Variable{
				Getter:    true,
				Name:      ident.Name,
				Setter:    !constant,
				Signature: prefix + " " + signature,
				Type:      typeString,
			}

			p.newExport(grammar, ident.Pos())
		}
	}

	return nil
}

// newExport creates an export from the given interface based on the current
// state of the collector.
func (p *PackageCollector) newExport(grammar interface{}, pos token.Pos) {
	position := p.fileSet.Position(pos)

	var export payloads.Export

	pkg := p.currentPkg()

	switch g := grammar.(type) {
	case nil:
		export = payloads.NewPackageExport()
		export.Key = pkg
		export.ParentKey = ""
	case *payloads.Class:
		export = payloads.NewClassExport(g)
		export.Key = pkg + "/" + g.Name
		export.ParentKey = pkg
	case *payloads.Field:
		export = payloads.NewFieldExport(g)
		export.Key = pkg + "/" + p.lastType + "/" + g.Name
		export.ParentKey = pkg + "/" + p.lastType
	case *payloads.Function:
		export = payloads.NewFunctionExport(g)
		export.Key = pkg + "/" + g.Name
		export.ParentKey = pkg
	case *payloads.Method:
		export = payloads.NewMethodExport(g)
		export.Key = pkg + "/" + g.Receiver + "/" + g.Name
		export.ParentKey = pkg + "/" + g.Receiver
	case *payloads.Variable:
		export = payloads.NewVariableExport(g)
		export.Key = pkg + "/" + g.Name
		export.ParentKey = pkg
	default:
		panic(fmt.Sprintf("invalid grammar type: %v", reflect.TypeOf(g)))
	}

	export.Meta.Line = position.Line
	export.Meta.URI = p.currentURI()

	if p.Debug {
		bytes, err := json.Marshal(export)
		if err != nil {
			panic(err)
		}
		log.Printf("%s\n", bytes)
	}

	p.exports[export.Key] = export
}

// nodeToString returns the source text for a given node.
func (p *PackageCollector) nodeToString(node ast.Node) string {
	start := p.fileSet.Position(node.Pos()).Offset
	end := p.fileSet.Position(node.End()).Offset
	return string(p.fileText[start:end])
}
