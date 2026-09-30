local primitiveSchemaBuilders = require("@builders/primitives")
const core = require("@packages/typed_core")

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

typed.formatIssues = core.parseIssue.formatIssues
typed.formatIssue = core.parseIssue.formatIssue

export type infer<T> = core.infer<T>

export type shape<T> = core.shape<T>

export type metadata<T> = core.metadata<T>

export type Schema<T, S = nil, M = nil> = core.Schema<T, S, M>

export type ParseResult<T> = core.ParseResult<T>

export type ParseIssue = core.ParseIssue

return typed
