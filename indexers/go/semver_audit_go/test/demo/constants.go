package demo

// Private

const privateStringConst = ""
const privateIntConst = 0
const privateReassignedStringConst = privateStringConst
const privateStringExpressionConst = privateStringConst + ""
const privateIntExpressionConst = 0 + 1
const (
	privateCompositeStringConst = ""
	privateCompositeIntConst    = 0
)

// Public

const PublicStringConst = ""
const PublicIntConst = 0
const PublicReassignedStringConst = PublicStringConst
const PublicStringExpressionConst = PublicStringConst + ""
const PublicIntExpressionConst = 0 + 1
const (
	PublicCompositeStringConst = ""
	PublicCompositeIntConst    = 0
)
const PublicConstAssignedToPrivateConst = privateStringConst
