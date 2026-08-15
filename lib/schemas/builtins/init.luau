const schema = require("../schema")
const primitive = require("./base/primitive")

const function primitiveFn<T>(typeName: string): () -> schema.Schema<T>
	return function()
		return primitive<<T>>(typeName)
	end
end

const primitives = {}

primitives.boolean = primitiveFn<<boolean>>("boolean")

primitives.number = require("@self/number")

primitives.string = require("@self/string")

primitives["nil"] = primitiveFn<<nil>>("nil")
primitives.none = primitives["nil"]

primitives.vector = primitiveFn<<vector>>("vector")

primitives.buffer = primitiveFn<<Buffer>>("buffer")

primitives["function"] = primitiveFn<<(...any) -> ...any>>("function")
primitives.callable = primitives["function"]

-- there isnt a type definition for userdata in luau
-- im just gonna keep it as unknown until there is a
-- type definition i can use for it
primitives.userdata = primitiveFn<<unknown>>("userdata")

return primitives
