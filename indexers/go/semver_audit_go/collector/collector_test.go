package collector

import (
	"testing"

	"github.com/Workiva/semver-audit/indexers/go/semver_audit_go/payloads"
	"github.com/stretchr/testify/assert"
)

var exports map[string]payloads.Export

func init() {
	exports = CollectFromPaths([]string{"../test/demo"})
}

func TestSiblings_Collide(t *testing.T) {
	// There are two sibling directories.  Each contains a package with the same name.
	// Each package has a method with the same name, but a different return type.
	// By not specifying them as separate paths, they will (eventually) collide.
	collectionPaths := []string{"../test/multipackage"}
	previousExports := CollectFromPaths(collectionPaths)

	collided := false

	for i := 0; i < 100; i++ {
		exports := CollectFromPaths(collectionPaths)
		r1, r2 := getReturnForMethodInTwoExports(t, previousExports, exports, "sibling/PublicStruct/PublicMultiReturn")
		if r1 != r2 {
			collided = true
		}
		previousExports = exports
	}

	assert.True(t, collided)
}

func TestSiblings_SeparateLibraries(t *testing.T) {
	// Since the we separately specified two libraries containing a package with the same name,
	// each library is namespaces with their path, avoiding collisions, unlike TestSiblings_Collide
	collectionPaths := []string{"../test/multipackage/sibling", "../test/multipackage/sibling2"}
	previousExports := CollectFromPaths(collectionPaths)

	// Over the course of 10 runs, the previous and current exports should always match.
	for i := 0; i < 10; i++ {
		exports := CollectFromPaths(collectionPaths)
		verifyMethodTwoExports(t, previousExports, exports, "../test/multipackage/sibling/sibling/PublicStruct/PublicMultiReturn")
		verifyMethodTwoExports(t, previousExports, exports, "../test/multipackage/sibling2/sibling/PublicStruct/PublicMultiReturn")
		previousExports = exports
	}

}

func TestPublicConstants(t *testing.T) {
	verifyConstant(t, "demo/PublicStringConst")
	verifyConstant(t, "demo/PublicIntConst")
	verifyConstant(t, "demo/PublicReassignedStringConst")
	verifyConstant(t, "demo/PublicStringExpressionConst")
	verifyConstant(t, "demo/PublicIntExpressionConst")
	verifyConstant(t, "demo/PublicCompositeStringConst")
	verifyConstant(t, "demo/PublicCompositeIntConst")
	verifyConstant(t, "demo/PublicConstAssignedToPrivateConst")
}

func TestPrivateConstants(t *testing.T) {
	verifyDoesNotExist(t, "privateStringConst")
	verifyDoesNotExist(t, "privateIntConst")
	verifyDoesNotExist(t, "privateReassignedStringConst")
	verifyDoesNotExist(t, "privateStringExpressionConst")
	verifyDoesNotExist(t, "privateIntExpressionConst")
	verifyDoesNotExist(t, "privateCompositeStringConst")
	verifyDoesNotExist(t, "privateCompositeIntConst")
}

func TestGenerics(t *testing.T) {
	verifyClass(t, "demo/GenericStruct")
	verifyField(t, "demo/GenericStruct/Value", "T")
	verifyMethod(t, "demo/GenericStruct/GetValueFromValueReceiver", "T")
	verifyMethod(t, "demo/GenericStruct/GetValueFromPointerReceiver", "T")
}

func TestPublicInterfaces(t *testing.T) {
	verifyInterface(t, "demo/PublicInterface")
}

func TestPrivateInterfaces(t *testing.T) {
	verifyDoesNotExist(t, "demo/privateInterface")
}

func TestPublicMethods(t *testing.T) {
	verifyClass(t, "demo/PublicStruct")
	verifyMethod(t, "demo/PublicStruct/PublicStringStringMethod", "string")
	verifyMethod(t, "demo/PublicStruct/PublicStringErrorMethod", "error")
	verifyMethod(t, "demo/PublicStruct/PublicStringVoidMethod", "")
	verifyMethod(t, "demo/PublicStruct/PublicVoidVoidMethod", "")
	verifyMethod(t, "demo/PublicStruct/PublicMultiReturn", "(string, error)")
	verifyMethod(t, "demo/PublicStruct/NonPointerMethod", "")
	// Regression test for methods declared in a different file than their receiver struct,
	// when there is another struct defined above the method.
	verifyDoesNotExist(t, "demo/AnotherPublicStruct/NonLocalMethod")
	verifyDoesNotExist(t, "demo/AnotherPublicStruct/NonLocalMethod")
	verifyMethod(t, "demo/PublicStruct/NonLocalMethod", "string")
	// Regression test for public methods on private structs
	verifyDoesNotExist(t, "demo/privateStruct")
	verifyDoesNotExist(t, "demo/privateStruct/PublicMethodOnPrivateStruct")
}

func TestPrivateMethods(t *testing.T) {
	verifyDoesNotExist(t, "demo/PublicStruct/privateMethod")
}

func TestPublicTypes(t *testing.T) {
	verifyClass(t, "demo/PublicType")
}

func TestPrivateTypes(t *testing.T) {
	verifyDoesNotExist(t, "demo/privateType")
}

func TestPublicFields(t *testing.T) {
	verifyField(t, "demo/PublicType/PublicStringField", "string")
	verifyField(t, "demo/PublicType/PublicStringSliceField", "[]string")
	verifyDoesNotExist(t, "demo/privateType/PublicStringField")
	verifyDoesNotExist(t, "demo/privateType/PublicStringSliceField")
}

func TestPrivateFields(t *testing.T) {
	verifyDoesNotExist(t, "demo/PublicType/privateStringField")
	verifyDoesNotExist(t, "demo/PublicType/privateStringSliceField")
	verifyDoesNotExist(t, "demo/privateType/privateStringField")
	verifyDoesNotExist(t, "demo/privateType/privateStringSliceField")
}

func TestPublicVariables(t *testing.T) {
	verifyVariable(t, "demo/PublicStringVar", "string")
	verifyVariable(t, "demo/PublicIntVar", "int")
	verifyVariable(t, "demo/PublicCompositeStringVar", "string")
	verifyVariable(t, "demo/PublicCompositeIntVar", "int")
	verifyVariable(t, "demo/PublicStringVarTyped", "string")
	verifyVariable(t, "demo/PublicIntVarTyped", "int")
	verifyVariable(t, "demo/PublicReassignedStringVarTyped", "string")
	verifyVariable(t, "demo/PublicStringExpressionVarTyped", "string")
	verifyVariable(t, "demo/PublicIntExpressionVarTyped", "int")
	verifyVariable(t, "demo/PublicCompositeStringVarTyped", "string")
	verifyVariable(t, "demo/PublicCompositeIntVarTyped", "int")
	verifyVariable(t, "demo/PublicStringSliceVarTyped", "[]string")
	verifyVariable(t, "demo/PublicMapVarTyped", "map[string]string")
	verifyVariable(t, "demo/PublicVarAssignedToPrivateVarTyped", "string")
}

func TestPrivateVariables(t *testing.T) {
	verifyDoesNotExist(t, "demo/privateStringVar")
	verifyDoesNotExist(t, "demo/privateIntVar")
	verifyDoesNotExist(t, "demo/privateReassignedStringVar")
	verifyDoesNotExist(t, "demo/privateStringExpressionVar")
	verifyDoesNotExist(t, "demo/privateIntExpressionVar")
	verifyDoesNotExist(t, "demo/privateCompositeStringVar")
	verifyDoesNotExist(t, "demo/privateCompositeIntVar")
}

func TestTypeInferredSymbols(t *testing.T) {
	// Some symbols don't have type information embedded in the AST. In order
	// to recover reliable type information for these we would need to run the
	// type checker. However, the type checker doesn't know about build tags,
	// so we would need to run the audit repeatedly with all valid flag
	// combinations. Instead, we attempt inference for some literals (like
	// ints) and use "unknown" otherwise. This isn't ideal, but it greatly
	// simplifies the tool and can be easily remediated by teams that desire
	// it by simply adding types to the relevant symbols.
	verifyVariable(t, "demo/PublicReassignedStringVar", "unknown")
	verifyVariable(t, "demo/PublicStringExpressionVar", "unknown")
	verifyVariable(t, "demo/PublicIntExpressionVar", "unknown")
	verifyVariable(t, "demo/PublicVarAssignedToPrivateVar", "unknown")
}

// Helpers

func verifyClass(t *testing.T, exportKey string) {
	e := verifyExists(t, exportKey, "class")
	if e != nil {
		g := e.Grammar.(*payloads.Class)
		assert.False(t, g.IsAbstract)
		assert.Empty(t, g.Extends)
		assert.Empty(t, g.Implements)
		assert.Empty(t, g.Mixins)
	}
}

func verifyConstant(t *testing.T, exportKey string) {
	e := verifyExists(t, exportKey, "variable")
	if e != nil {
		g := e.Grammar.(*payloads.Variable)
		assert.True(t, g.Getter)
		assert.False(t, g.Setter)
	}
}

func verifyDoesNotExist(t *testing.T, exportKey string) {
	for key, export := range exports {
		if key == exportKey || export.Key == exportKey {
			t.Errorf("found '%s' but should not have", exportKey)
		}
	}
}

func verifyExistsInExports(t *testing.T, exports map[string]payloads.Export, exportKey, exportType string) *payloads.Export {
	for key, export := range exports {
		if key == exportKey || export.Key == exportKey {
			assert.Equal(t, exportKey, key)
			assert.Equal(t, exportKey, export.Key)
			return &export
		}
	}
	t.Errorf("did not find '%s' of type '%s'", exportKey, exportType)
	return nil
}

func verifyExists(t *testing.T, exportKey, exportType string) *payloads.Export {
	return verifyExistsInExports(t, exports, exportKey, exportType)
}

func verifyField(t *testing.T, exportKey, exportType string) {
	e := verifyExists(t, exportKey, "field")
	if e != nil {
		g := e.Grammar.(*payloads.Field)
		assert.False(t, g.IsAbstract)
		assert.Equal(t, exportType, g.Type)
	}
}

func verifyInterface(t *testing.T, exportKey string) {
	e := verifyExists(t, exportKey, "class")
	if e != nil {
		g := e.Grammar.(*payloads.Class)
		assert.True(t, g.IsAbstract)
		assert.Empty(t, g.Extends)
		assert.Empty(t, g.Implements)
		assert.Empty(t, g.Mixins)
	}
}

func verifyMethodTwoExports(t *testing.T, firstExports, secondExports map[string]payloads.Export, methodExportKey string) {
	returnType1, returnType2 := getReturnForMethodInTwoExports(t, firstExports, secondExports, methodExportKey)
	assert.Equal(t, returnType1, returnType2)

}

func getReturnForMethodInTwoExports(t *testing.T, firstExports map[string]payloads.Export, secondExports map[string]payloads.Export, methodExportKey string) (string, string) {
	e1 := verifyExistsInExports(t, firstExports, methodExportKey, "method")
	g1 := e1.Grammar.(*payloads.Method)

	e2 := verifyExistsInExports(t, secondExports, methodExportKey, "method")
	g2 := e2.Grammar.(*payloads.Method)

	returnType1 := g1.ReturnType
	returnType2 := g2.ReturnType
	return returnType1, returnType2
}

func verifyMethod(t *testing.T, methodExportKey, returnType string) {
	e := verifyExists(t, methodExportKey, "method")
	if e != nil {
		g := e.Grammar.(*payloads.Method)
		assert.Empty(t, g.Parameters.Named)
		assert.False(t, g.Static)
		assert.Equal(t, returnType, g.ReturnType)
	}
}

func verifyVariable(t *testing.T, exportKey, variableType string) {
	e := verifyExists(t, exportKey, "variable")
	if e != nil {
		g := e.Grammar.(*payloads.Variable)
		assert.True(t, g.Getter)
		assert.True(t, g.Setter)
		assert.Equal(t, variableType, g.Type)
	}
}
