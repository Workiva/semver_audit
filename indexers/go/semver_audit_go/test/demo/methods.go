package demo

// Public

type PublicStruct struct{}

func (p *PublicStruct) PublicStringStringMethod(s string) string {
	return ""
}

func (p *PublicStruct) PublicStringErrorMethod(s string) error {
	return nil
}

func (p *PublicStruct) PublicStringVoidMethod(s string) {}

func (p *PublicStruct) PublicVoidVoidMethod() {}

func (p *PublicStruct) PublicMultiReturn() (string, error) {
	return "", nil
}

func (p PublicStruct) NonPointerMethod() {}

// Private

func (p *PublicStruct) privateMethod() {}

type privateStruct struct{}

func (p *privateStruct) PublicMethodOnPrivateStruct() {}
