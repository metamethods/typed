const core = require("@packages/typed_core")
const like = require("./like")

const function builtinSchemaBuilder<T>(typeName: string): () -> core.Schema<T>
	return function()
		return like<<T>>(typeName)
	end
end

const primitives = {}

primitives.none = require("@self/none")
primitives["nil"] = primitives.none

primitives.boolean = builtinSchemaBuilder<<boolean>>("boolean")

primitives.number = require("@self/number")

primitives.string = require("@self/string")

primitives.vector = builtinSchemaBuilder<<vector>>("vector")

primitives.buffer = builtinSchemaBuilder<<buffer>>("buffer")

primitives["function"] = builtinSchemaBuilder<<(...any) -> ...any>>("function")
primitives.callable = primitives["function"]

-- there isnt a type definition for userdata in luau
-- im just gonna keep it as unknown until there is a
-- type definition i can use for it
primitives.userdata = builtinSchemaBuilder<<unknown>>("userdata")

return primitives
