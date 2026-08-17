const builtins = require("../builtins")
const union = require("../combinators/union")

const function optionalSchemaBuilder<T>(innerSchema: T)
	return union(innerSchema, builtins.none())
end

return optionalSchemaBuilder
