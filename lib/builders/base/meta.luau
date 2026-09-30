const schema = require("../../schema")
const shared = require("../../shared")

const function metaSchemaBuilder<S, NewM>(sourceSchema: S, metadata: NewM): schema.Schema<shared.infer<S>, shared.shape<S>, NewM>
	const sourceSchema: schema.SchemaFromGeneric<S> = sourceSchema
	const copiedSchema = schema.createSchema<<shared.infer<S>, shared.shape<S>, NewM>>(
		sourceSchema.type,
		sourceSchema.parse,
		sourceSchema.shape,
		metadata
	)
	return copiedSchema
end

return metaSchemaBuilder
