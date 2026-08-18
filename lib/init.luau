local builtinSchemaBuilders = require("@self/builders/builtins")
local issue = require("@self/issue")
local result = require("@self/result")
local schema = require("@self/schema")
local shared = require("@self/shared")

local typed = {}

-- base
typed.any = require("@self/builders/base/any")
typed.unknown = require("@self/builders/base/unknown")
typed.never = require("@self/builders/base/never")
typed.literal = require("@self/builders/base/literal")
typed.is = require("@self/builders/base/is")

-- builtins
typed.boolean = builtinSchemaBuilders.boolean
typed.number = builtinSchemaBuilders.number
typed.string = builtinSchemaBuilders.string
typed["nil"] = builtinSchemaBuilders["nil"]
typed.none = builtinSchemaBuilders.none
typed.vector = builtinSchemaBuilders.vector
typed.buffer = builtinSchemaBuilders.buffer
typed["function"] = builtinSchemaBuilders["function"]
typed.callable = builtinSchemaBuilders.callable
typed.userdata = builtinSchemaBuilders.userdata

-- structures
typed.table = require("@self/builders/structures/table")
typed.array = require("@self/builders/structures/array")
typed.iterable = require("@self/builders/structures/iterable")

-- modifiers
typed.optional = require("@self/builders/modifiers/optional")
typed.transform = require("@self/builders/modifiers/transform")

-- combinators
typed.union = require("@self/builders/combinators/union")
typed.intersect = require("@self/builders/combinators/intersect")

typed.formatIssues = issue.formatIssues
typed.formatIssue = issue.formatIssue

export type infer<T> = shared.infer<T>

export type Schema<T, S = nil, M = nil> = schema.Schema<T, S, M>

export type ValidateResult = result.ValidateResult

export type ParseResult<T> = result.ParseResult<T>

return typed
