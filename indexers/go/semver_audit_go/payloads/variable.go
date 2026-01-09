package payloads

// Variable represents a top-level variable or constant declaration.
type Variable struct {
	Getter bool `json:"getter"`

	Name string `json:"name"`

	Setter bool `json:"setter"`

	Signature string `json:"signature"`

	Type string `json:"type"`
}
