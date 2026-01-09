package payloads

// Parameter represents a function or method parameter.
type Parameter struct {
	Name string `json:"name"`

	Required bool `json:"required"`

	Type string `json:"type"`
}
