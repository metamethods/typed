const schema = require("../../schema")
const shared = require("../../shared")

const function metaSchemaBuilder<S, NewM>(sourceSchema: S, metadata: NewM): schema.Schema<shared.infer<S>, shared.shape<S>, NewM>
	const sourceSchema: schema.AnySchema = sourceSchema
	const copiedSchema = schema.createSchema(sourceSchema.type, sourceSchema.parse, sourceSchema.shape)
	copiedSchema.metadata = metadata
	return copiedSchema
end

return metaSchemaBuilder
