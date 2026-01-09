package demo

// Private

type privateType struct {
	privateStringField string
	PublicStringField  string

	privateStringSliceField []string
	PublicStringSliceField  []string
}

// Public

type PublicType struct {
	privateStringField string
	PublicStringField  string

	privateStringSliceField []string
	PublicStringSliceField  []string
}
