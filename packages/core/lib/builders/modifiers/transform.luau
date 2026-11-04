const engine = require("@packages/engine")

const function transformSchemaBuilder<S>(sourceSchema: S)
	const sourceSchema: engine.SchemaFromGeneric<S> = sourceSchema

	return function<R>(transform: (engine.infer<S>) -> R)
		return engine.schema.createSchema<<R, engine.InnerSchema<engine.shape<S>, engine.metadata<S>>>>(
			"transform",
			function(value)
				const sourceSchema: engine.SchemaFromGeneric<S> = sourceSchema

				const sourceSchemaParseResult = sourceSchema.parse(value)

				if not sourceSchemaParseResult.ok then
					return sourceSchemaParseResult
				end

				return engine.parseResult.ok(transform(sourceSchemaParseResult.value))
			end,
			engine.schema.innerSchema(sourceSchema),
			sourceSchema.metadata
		)
	end
end

return transformSchemaBuilder
