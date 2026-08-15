const schema = require("../../schema")
const builtins = require("../builtins")
const iterable = require("./iterable")

const function arraySchema<T>(valueSchema: schema.Schema<T>)
	return iterable(builtins.number(), valueSchema)
end

return arraySchema
