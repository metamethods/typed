const primitives = require("../primitives")
const union = require("../combinators/union")

const function optionalSchemaBuilder<S>(innerSchema: S)
	return union(innerSchema, primitives.none())
end

return optionalSchemaBuilder
