const schema = require("@lib/schema")
const like = require("./like")

const function builtinSchemaBuilder<T>(typeName: string): () -> schema.Schema<T>
	return function()
		return like<<T>>(typeName)
	end
end

const luau = {}

luau.boolean = builtinSchemaBuilder<<boolean>>("boolean")

luau.number = require("@self/number")

luau.string = require("@self/string")

luau.vector = builtinSchemaBuilder<<vector>>("vector")

luau.buffer = builtinSchemaBuilder<<buffer>>("buffer")

luau["function"] = builtinSchemaBuilder<<(...any) -> ...any>>("function")
luau.callable = luau["function"]

-- there isnt a type definition for userdata in luau
-- im just gonna keep it as unknown until there is a
-- type definition i can use for it
luau.userdata = builtinSchemaBuilder<<unknown>>("userdata")

return luau
