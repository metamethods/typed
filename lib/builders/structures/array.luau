const luau = require("@builders/luau")
const iterable = require("./iterable")

const function arraySchemaBuilder<S>(valueSchema: S)
	return iterable(luau.number(), valueSchema)
end

return arraySchemaBuilder
