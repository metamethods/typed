const result = require("../../result")
const schema = require("../../schema")
const shared = require("../../shared")

const function transformSchemaBuilder<S>(sourceSchema: S)
	const sourceSchema: schema.SchemaFromGeneric<S> = sourceSchema

	return function<R>(transform: (shared.infer<S>) -> R)
		return schema.createSchema<<R, schema.InnerSchema<shared.shape<S>, shared.metadata<S>>>>(
			"transform",
			function(value)
				const sourceSchema: schema.SchemaFromGeneric<S> = sourceSchema

				const sourceSchemaParseResult = sourceSchema.parse(value)

				if not sourceSchemaParseResult.ok then
					return sourceSchemaParseResult
				end

				return result.parse.ok(transform(sourceSchemaParseResult.value))
			end,
			schema.innerSchema(sourceSchema),
			sourceSchema.metadata
		)
	end
end

return transformSchemaBuilder
