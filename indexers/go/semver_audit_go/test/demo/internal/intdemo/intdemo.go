package intdemo

var InternalVariable int = 0

func InternalFunction(a string) (string, error) {
	return "", nil
}

type InternalStruct struct {
	A int
	B string
	c int
	d string
}

type InternalInterface interface {
	A() int
	b() int
}
