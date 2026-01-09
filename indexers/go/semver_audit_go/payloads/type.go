package payloads

type Type string

// The constants here correspond to the export types accepted by the semver service.
const (
	ClassType    Type = "class"
	FieldType    Type = "field"
	FunctionType Type = "function"
	MethodType   Type = "method"
	PackageType  Type = "package"
	VariableType Type = "variable"
	//...
)
