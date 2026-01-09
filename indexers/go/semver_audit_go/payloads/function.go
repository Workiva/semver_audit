package payloads

var _ FunctionOrMethod = (*Function)(nil)

// Function represents a top-level public function.
type Function struct {
	Name string `json:"name"`

	Parameters Parameters `json:"parameters"`

	ReturnType string `json:"return_type"`

	Signature string `json:"signature"`
}

func NewFunction() *Function {
	return &Function{
		Parameters: NewParameters(),
	}
}

func (f *Function) AddPositionalParameter(p Parameter) {
	f.Parameters.Positional = append(f.Parameters.Positional, p)
}

func (f *Function) SetName(name string) {
	f.Name = name
}

func (f *Function) SetReturnType(returnType string) {
	f.ReturnType = returnType
}

func (f *Function) SetSignature(signature string) {
	f.Signature = signature
}
