package payloads

// Class represents a semver "class" element, which in Go is a struct. This type
// should probably be used through its factory in order to get default values
// since several of the fields will never be used in Go.
type Class struct {
	Extends []string `json:"extends"`

	Implements []string `json:"implements"`

	IsAbstract bool `json:"is_abstract"`

	Mixins []string `json:"mixins"`

	Name string `json:"name"`

	Signature string `json:"signature"`
}

func NewClass(name string) *Class {
	return &Class{
		Extends:    []string{},
		Implements: []string{},
		Mixins:     []string{},
		Name:       name,
	}
}
