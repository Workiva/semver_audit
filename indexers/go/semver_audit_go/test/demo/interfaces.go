package demo

type PublicInterface interface {
	PublicInterfaceMethod() string
	privateInterfaceMethod() string
}

type privateInterface interface {
	PublicInterfaceMethod() string
	privateInterfaceMethod() string
}
