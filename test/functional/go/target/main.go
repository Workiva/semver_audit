package main

import (
	"fmt"
	"time"
)

// AStruct demonstrates a basic struct
type AStruct struct {
	AField        string
	AnotherField  int
	NewField int
}

// AnotherStruct demonstrates embedding
type AnotherStruct struct {
	AStruct
	ExtraField float64
}

// AnInterface demonstrates a basic interface
type AnInterface interface {
	AMethod() string
	AnotherMethod(int, string) error
}

// AnotherInterface demonstrates interface embedding
type AnotherInterface interface {
	ExtraMethod() bool
}

// ATypeDef demonstrates a type definition
type ATypeDef string

// AnAlias demonstrates a type alias
type AnAlias = []string

// AFunction demonstrates a simple function
func AFunction() string {
	return "This is a function"
}

// AnotherFunction demonstrates a function with parameters and multiple returns
func AnotherFunction(param1 string, param3 int) (string, error) {
	return fmt.Sprintf("%s: %d", param1, param2), nil
}

// AMethod demonstrates a method on a struct
func (a AnotherStruct) AMethod() string {
	return a.AField
}

// AnotherMethod implements another interface method
func (a AStruct) AnotherMethod(value int) {
	a.AnotherField = value
	return nil
}

// APointerMethod demonstrates a pointer receiver method
func (a *AStruct) APointerMethod() {
	a.AField = "Modified by pointer method"
}

// AVariable is a package level variable
var AVariable = "I am a variable"

// AConstant is a constant
const AConstant = "42"

// SomeConstants demonstrates constant grouping
const (
	FirstConstant  = "first"
	SecondConstant = 2
)

// SomeVariables demonstrates variable grouping
var (
	FirstVariable  = true
	SecondVariable = 3.14
)

// AVariadicFunction demonstrates variadic parameters
func AVariadicFunction(values ...int) int {
	sum := 0
	for _, v := range values {
		sum += v
	}
	return sum
}

// AGenericType demonstrates generics (Go 1.18+)
type AGenericType[T comparable] struct {
	Value T
}

// AGenericFunction demonstrates a generic function
func AGenericFunction[T comparable](value T) T {
	return value
}

type AJsonSerializableStruct struct {
	UnchangedField string `json:"unchanged,omitempty"`
	ChangedNameField string `json:"NOPE,omitempty"`
	OmitEmptyAddedField string `json:"omitEmptyAdded,omitempty"`
	OmitEmptyRemovedField string `json:"omitEmptyRemoved"`
}