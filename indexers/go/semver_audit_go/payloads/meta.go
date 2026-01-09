package payloads

// Meta represents the meta information included in the report payload such
// as the line number and import location of the symbol in question.
type Meta struct {
	Line int `json:"line"`

	URI string `json:"uri"`
}
