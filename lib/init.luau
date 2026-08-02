const schema = require("@self/schema")
const primitives = require("@self/schemas/primitives")
const shared = require("@self/shared")

const typed = {}

-- primitive
typed.boolean = primitives.boolean
typed.number = primitives.number
typed.string = primitives.string
typed.table = primitives.table
typed.array = primitives.array
typed.iterable = primitives.iterable
typed["nil"] = primitives["nil"]
typed.none = primitives.none
typed.vector = primitives.vector
typed.buffer = primitives.buffer
typed["function"] = primitives["function"]
typed.callable = primitives.callable
typed.userdata = primitives.userdata

-- utility
typed.any = require("@self/schemas/any")
typed.literal = require("@self/schemas/literal")
typed.optional = require("@self/schemas/optional")
typed.transform = require("@self/schemas/transform")
typed.union = require("@self/schemas/union")
typed.intersect = require("@self/schemas/intersect")

export type infer<T> = shared.infer<T>

export type Schema<T> = schema.Schema<T>

return typed
