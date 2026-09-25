const builtins = require("../builtins")
const union = require("../combinators/union")

const function optionalSchemaBuilder<S>(innerSchema: S)
	return union(innerSchema, builtins.none())
end

return optionalSchemaBuilder
