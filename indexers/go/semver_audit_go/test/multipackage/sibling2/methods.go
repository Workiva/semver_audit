package sibling

type PublicStruct struct{}

func (p *PublicStruct) PublicMultiReturn() (int, error) {
	return 0, nil
}
