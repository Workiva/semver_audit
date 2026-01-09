package subdemo

var PublicVar = ""

var PublicVarTyped string = ""

func PublicFunc(a int) int {
	return 0
}

type PublicStruct struct {
	PublicField string
}

func (p *PublicStruct) PublicMethod(a int) ([]int, error) {
	return []int{0, 1}, nil
}
