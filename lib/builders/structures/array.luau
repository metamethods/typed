const builtins = require("../builtins")
const iterable = require("./iterable")

const function arraySchemaBuilder<S>(valueSchema: S)
	return iterable(builtins.number(), valueSchema)
end

return arraySchemaBuilder
