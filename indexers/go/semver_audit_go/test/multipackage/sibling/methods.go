package sibling

type PublicStruct struct{}

func (p *PublicStruct) PublicMultiReturn() (string, error) {
	return "", nil
}
