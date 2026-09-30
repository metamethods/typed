const core = require("@packages/typed_core")

const function transformSchemaBuilder<S>(sourceSchema: S)
	const sourceSchema: core.SchemaFromGeneric<S> = sourceSchema

	return function<R>(transform: (core.infer<S>) -> R)
		return core.schema.createSchema<<R, core.InnerSchema<core.shape<S>, core.metadata<S>>>>(
			"transform",
			function(value)
				const sourceSchema: core.SchemaFromGeneric<S> = sourceSchema

				const sourceSchemaParseResult = sourceSchema.parse(value)

				if not sourceSchemaParseResult.ok then
					return sourceSchemaParseResult
				end

				return core.parseResult.ok(transform(sourceSchemaParseResult.value))
			end,
			core.schema.innerSchema(sourceSchema),
			sourceSchema.metadata
		)
	end
end

return transformSchemaBuilder
