package payloads

// Field represents a public struct field.
type Field struct {
	IsAbstract bool `json:"is_abstract"`

	Name string `json:"name"`

	Signature string `json:"signature"`

	Type string `json:"type"`

	Tags map[string][]string `json:"tags,omitempty"`
}
