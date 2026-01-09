package payloads

// FunctionOrMethod represents a callable element in a Go program,
// specifically a declared method or function. This allows us to
// share common logic for handling these, despite their differences
// (methods have receivers).
type FunctionOrMethod interface {
	AddPositionalParameter(p Parameter)
	SetName(name string)
	SetReturnType(returnType string)
	SetSignature(signature string)
}
