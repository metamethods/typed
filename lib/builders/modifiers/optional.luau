const schema = require("../../schema")
const builtins = require("../builtins")
const union = require("../combinators/union")

const function optionalSchemaBuilder<T, S, M>(innerSchema: schema.Schema<T, S, M>)
	return union(innerSchema, builtins.none())
end

return optionalSchemaBuilder
