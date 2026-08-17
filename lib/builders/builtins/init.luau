const schema = require("../schema")
const primitive = require("./base/primitive")

const function primitiveSchemaBuilderFn<T>(typeName: string): () -> schema.Schema<T>
	return function()
		return primitive<<T>>(typeName)
	end
end

const primitives = {}

primitives.boolean = primitiveSchemaBuilderFn<<boolean>>("boolean")

primitives.number = require("@self/number")

primitives.string = require("@self/string")

primitives["nil"] = primitiveSchemaBuilderFn<<nil>>("nil")
primitives.none = primitives["nil"]

primitives.vector = primitiveSchemaBuilderFn<<vector>>("vector")

primitives.buffer = primitiveSchemaBuilderFn<<Buffer>>("buffer")

primitives["function"] = primitiveSchemaBuilderFn<<(...any) -> ...any>>("function")
primitives.callable = primitives["function"]

-- there isnt a type definition for userdata in luau
-- im just gonna keep it as unknown until there is a
-- type definition i can use for it
primitives.userdata = primitiveSchemaBuilderFn<<unknown>>("userdata")

return primitives
