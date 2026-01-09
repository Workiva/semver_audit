package demo

// Private

var privateStringVar = ""
var privateIntVar = 0
var privateReassignedStringVar = privateStringConst
var privateStringExpressionVar = privateStringConst + ""
var privateIntExpressionVar = 0 + 1
var (
	privateCompositeStringVar = ""
	privateCompositeIntVar    = 0
)

// Public

var PublicStringVar = ""
var PublicIntVar = 0
var PublicReassignedStringVar = PublicStringConst
var PublicStringExpressionVar = PublicStringConst + ""
var PublicIntExpressionVar = 0 + 1
var (
	PublicCompositeStringVar = ""
	PublicCompositeIntVar    = 0
)
var PublicVarAssignedToPrivateVar = privateStringVar
var PublicStringVarTyped string = ""
var PublicIntVarTyped int = 0
var PublicReassignedStringVarTyped string = PublicStringConst
var PublicStringExpressionVarTyped string = PublicStringConst + ""
var PublicIntExpressionVarTyped int = 0 + 1
var (
	PublicCompositeStringVarTyped string = ""
	PublicCompositeIntVarTyped    int    = 0
)
var PublicStringSliceVarTyped []string = []string{""}
var PublicMapVarTyped map[string]string = map[string]string{}
var PublicVarAssignedToPrivateVarTyped string = privateStringVar
