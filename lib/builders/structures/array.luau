const schema = require("../../schema")
const builtins = require("../builtins")
const iterable = require("./iterable")

const function arraySchemaBuilder<T, S, M>(valueSchema: schema.Schema<T, S, M>)
	return iterable(builtins.number(), valueSchema)
end

return arraySchemaBuilder
