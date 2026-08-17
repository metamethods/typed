const builtins = require("../builtins")
const iterable = require("./iterable")

const function arraySchemaBuilder<T>(valueSchema: T)
	return iterable(builtins.number(), valueSchema)
end

return arraySchemaBuilder
