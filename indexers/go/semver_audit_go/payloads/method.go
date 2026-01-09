package payloads

var _ FunctionOrMethod = (*Method)(nil)

// Method represents a public struct method.
type Method struct {
	Name string `json:"name"`

	Parameters Parameters `json:"parameters"`

	// We track the receiver because in Go a method receiver isn't necessarily
	// defined "next to" its methods and we need it to compute the parent key.
	Receiver string `json:"-"`

	ReturnType string `json:"return_type"`

	Signature string `json:"signature"`

	Static bool `json:"static"`
}

func NewMethod(receiver string) *Method {
	return &Method{
		Parameters: NewParameters(),
		Receiver:   receiver,
	}
}

func (f *Method) AddPositionalParameter(p Parameter) {
	f.Parameters.Positional = append(f.Parameters.Positional, p)
}

func (f *Method) SetName(name string) {
	f.Name = name
}

func (f *Method) SetReturnType(returnType string) {
	f.ReturnType = returnType
}

func (f *Method) SetSignature(signature string) {
	f.Signature = signature
}
