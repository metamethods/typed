local issue = require("@self/issue")
local luauSchemaBuilders = require("@self/builders/luau")
local result = require("@self/result")
local schema = require("@self/schema")
local shared = require("@self/shared")

local typed = {}

-- core
typed.any = require("@self/builders/any")
typed.unknown = require("@self/builders/unknown")
typed.never = require("@self/builders/never")
typed.literal = require("@self/builders/literal")
typed.literals = require("@self/builders/literals")
typed.is = require("@self/builders/is")
typed.refine = require("@self/builders/refine")
typed.meta = require("@self/builders/meta")
typed.none = require("@self/builders/none")
typed["nil"] = typed.none

typed.table = require("@self/builders/structures/table")
typed.array = require("@self/builders/structures/array")
typed.iterable = require("@self/builders/structures/iterable")

typed.optional = require("@self/builders/modifiers/optional")
typed.transform = require("@self/builders/modifiers/transform")
typed.default = require("@self/builders/modifiers/default")

typed.union = require("@self/builders/combinators/union")
typed.intersect = require("@self/builders/combinators/intersect")

-- luau
typed.boolean = luauSchemaBuilders.boolean
typed.number = luauSchemaBuilders.number
typed.string = luauSchemaBuilders.string
typed.vector = luauSchemaBuilders.vector
typed.buffer = luauSchemaBuilders.buffer
typed["function"] = luauSchemaBuilders["function"]
typed.callable = luauSchemaBuilders.callable
typed.userdata = luauSchemaBuilders.userdata

-- roblox

typed.formatIssues = issue.formatIssues
typed.formatIssue = issue.formatIssue

export type infer<T> = shared.infer<T>

export type Schema<T, S = nil, M = nil> = schema.Schema<T, S, M>

export type InnerSchema<S = nil, M = nil> = schema.InnerSchema<S, M>

export type UnknownSchema = schema.UnknownSchema

export type AnySchema = schema.AnySchema

export type SchemaShape<S, M = any> = schema.Schema<any, S, M>

export type ParseResult<T> = result.ParseResult<T>

return typed
