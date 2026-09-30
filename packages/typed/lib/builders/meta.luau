const core = require("@packages/typed_core")

const function metaSchemaBuilder<S, NewM>(sourceSchema: S, metadata: NewM): core.Schema<core.infer<S>, core.shape<S>, NewM>
	const sourceSchema: core.SchemaFromGeneric<S> = sourceSchema
	const copiedSchema = core.schema.createSchema<<core.infer<S>, core.shape<S>, NewM>>(
		sourceSchema.type,
		sourceSchema.parse,
		sourceSchema.shape,
		metadata
	)
	return copiedSchema
end

return metaSchemaBuilder
