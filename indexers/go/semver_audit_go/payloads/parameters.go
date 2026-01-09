package payloads

// Parameters represents the collection of function or method parameters
// sent to the service with the report.
type Parameters struct {
	// Go does not have named parameters so this will always be empty.
	Named []Parameter `json:"named"`

	Positional []Parameter `json:"positional"`
}

func NewParameters() Parameters {
	return Parameters{
		Named:      []Parameter{},
		Positional: []Parameter{},
	}
}
