local primitiveSchemaBuilders = require("@builders/primitives")
const engine = require("@packages/engine")

local typed = {}

-- core
typed.any = require("@builders/any")
typed.unknown = require("@builders/unknown")
typed.never = require("@builders/never")
typed.literal = require("@builders/literal")
typed.literals = require("@builders/literals")
typed.is = require("@builders/is")
typed.like = require("@builders/like")
typed.refine = require("@builders/refine")
typed.meta = require("@builders/meta")

typed.none = primitiveSchemaBuilders.none
typed["nil"] = primitiveSchemaBuilders["nil"]
typed.boolean = primitiveSchemaBuilders.boolean
typed.number = primitiveSchemaBuilders.number
typed.string = primitiveSchemaBuilders.string
typed.vector = primitiveSchemaBuilders.vector
typed.buffer = primitiveSchemaBuilders.buffer
typed.callable = primitiveSchemaBuilders.callable
typed["function"] = primitiveSchemaBuilders["function"]
typed.userdata = primitiveSchemaBuilders.userdata

typed.table = require("@builders/structures/table")
typed.array = require("@builders/structures/array")
typed.iterable = require("@builders/structures/iterable")

typed.optional = require("@builders/modifiers/optional")
typed.transform = require("@builders/modifiers/transform")
typed.default = require("@builders/modifiers/default")

typed.union = require("@builders/combinators/union")
typed.intersect = require("@builders/combinators/intersect")

typed.formatIssues = engine.parseIssue.formatIssues
typed.formatIssue = engine.parseIssue.formatIssue

export type infer<T> = engine.infer<T>

export type shape<T> = engine.shape<T>

export type metadata<T> = engine.metadata<T>

export type Schema<T, S = nil, M = nil> = engine.Schema<T, S, M>

export type ParseResult<T> = engine.ParseResult<T>

export type ParseIssue = engine.ParseIssue

return typed
