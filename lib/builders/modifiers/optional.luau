const none = require("@builders/none")
const union = require("@builders/combinators/union")

const function optionalSchemaBuilder<S>(innerSchema: S)
	return union(innerSchema, none())
end

return optionalSchemaBuilder
