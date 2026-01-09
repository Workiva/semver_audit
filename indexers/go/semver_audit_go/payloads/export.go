package payloads

import "fmt"

// Export represents a basic export payload. This struct is intended to be
// embedded in more specific types that include a `Grammar` field.
type Export struct {
	// Key is a unique identifier for this export. For example, a package name
	// followed by a public function name would identify a function.
	Key string `json:"key"`

	// ParentKey is the key of the element that contains the current export,
	// such as a method contained within a type, or a function contained within
	// a package.
	ParentKey string `json:"parent_key"`

	// Type is the kind of the export. For example, "variable" for a top-level
	// variable in a Go package.
	Type Type `json:"type"`

	// Grammar is the portion of the payload that describes the interface of
	// this export. It is untyped here because it needs to be generic based
	// on the value of Type, but we never access these structs directly in code
	// so generating it wouldn't be terrible valuable.
	Grammar interface{} `json:"grammar"`

	// Meta is data unrelated to semver diffing but helpful for the PR comments
	// created by the service.
	Meta *Meta `json:"meta"`
}

func (e *Export) String() string {
	return fmt.Sprintf(`{Key: %s ParentKey: %s, Type: %s Grammar: %s}`, e.Key, e.ParentKey, e.Type, e.Grammar)

}

func NewClassExport(grammar *Class) Export {
	return Export{
		Grammar: grammar,
		Meta:    &Meta{},
		Type:    ClassType,
	}
}

func NewFieldExport(grammar *Field) Export {
	return Export{
		Grammar: grammar,
		Meta:    &Meta{},
		Type:    FieldType,
	}
}

func NewFunctionExport(grammar *Function) Export {
	return Export{
		Grammar: grammar,
		Meta:    &Meta{},
		Type:    FunctionType,
	}
}

func NewMethodExport(grammar *Method) Export {
	return Export{
		Grammar: grammar,
		Meta:    &Meta{},
		Type:    MethodType,
	}
}

func NewPackageExport() Export {
	return Export{
		Grammar: map[string]string{},
		Meta:    &Meta{},
		Type:    PackageType,
	}
}

func NewVariableExport(grammar *Variable) Export {
	return Export{
		Grammar: grammar,
		Meta:    &Meta{},
		Type:    VariableType,
	}
}
