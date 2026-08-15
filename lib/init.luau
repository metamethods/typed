const result = require("@self/result")
const issue = require("@self/issue")
const schema = require("@self/schema")
const builtins = require("@self/schemas/builtins")
const shared = require("@self/shared")

const typed = {}

-- base
typed.any = require("@self/schemas/base/any")
typed.literal = require("@self/schemas/base/literal")
typed.is = require("@self/schemas/base/is")
-- no im not exporting primitiveSchema; it is a moreso internal schema builder
-- although if demanded, i'll export it

-- builtins
typed.boolean = builtins.boolean
typed.number = builtins.number
typed.string = builtins.string
typed["nil"] = builtins["nil"]
typed.none = builtins.none
typed.vector = builtins.vector
typed.buffer = builtins.buffer
typed["function"] = builtins["function"]
typed.callable = builtins.callable
typed.userdata = builtins.userdata

-- structures
typed.table = require("@self/schemas/structures/table")
typed.array = require("@self/schemas/structures/array")
typed.iterable = require("@self/schemas/structures/iterable")

-- modifiers
typed.optional = require("@self/schemas/modifiers/optional")
typed.transform = require("@self/schemas/modifiers/transform")

-- combinators
typed.union = require("@self/schemas/combinators/union")
typed.intersect = require("@self/schemas/combinators/intersect")

typed.formatIssues = issue.formatIssues
typed.formatIssue = issue.formatIssue

export type infer<T> = shared.infer<T>

export type Schema<T> = schema.Schema<T>

export type ValidateResult = result.ValidateResult

export type ParseResult<T> = result.ParseResult<T>

return typed
