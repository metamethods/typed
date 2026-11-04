const engine = require("@packages/engine")

const function metaSchemaBuilder<S, NewM>(sourceSchema: S, metadata: NewM): engine.Schema<engine.infer<S>, engine.shape<S>, NewM>
	const sourceSchema: engine.SchemaFromGeneric<S> = sourceSchema
	const copiedSchema = engine.schema.createSchema<<engine.infer<S>, engine.shape<S>, NewM>>(
		sourceSchema.type,
		sourceSchema.parse,
		sourceSchema.shape,
		metadata
	)
	return copiedSchema
end

return metaSchemaBuilder
