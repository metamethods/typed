const schema = require("../schema")
const like = require("./base/like")

const function builtinSchemaBuilder<T>(typeName: string): () -> schema.Schema<T>
	return function()
		return like<<T>>(typeName)
	end
end

const builtins = {}

builtins.boolean = builtinSchemaBuilder<<boolean>>("boolean")

builtins.number = require("@self/number")

builtins.string = require("@self/string")

builtins["nil"] = builtinSchemaBuilder<<nil>>("nil")
builtins.none = builtins["nil"]

builtins.vector = builtinSchemaBuilder<<vector>>("vector")

builtins.buffer = builtinSchemaBuilder<<Buffer>>("buffer")

builtins["function"] = builtinSchemaBuilder<<(...any) -> ...any>>("function")
builtins.callable = builtins["function"]

-- there isnt a type definition for userdata in luau
-- im just gonna keep it as unknown until there is a
-- type definition i can use for it
builtins.userdata = builtinSchemaBuilder<<unknown>>("userdata")

return builtins
