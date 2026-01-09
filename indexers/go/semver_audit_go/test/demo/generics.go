package demo

type GenericStruct[T any] struct {
	Value T
}

func (g GenericStruct[T]) GetValueFromValueReceiver() T {
	return g.Value
}

func (g *GenericStruct[T]) GetValueFromPointerReceiver() T {
	return g.Value
}
