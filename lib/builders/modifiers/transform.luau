const result = require("../../result")
const schema = require("../../schema")
const shared = require("../../shared")

const function transformSchemaBuilder<S>(sourceSchema: S)
	return function<R>(transform: (shared.infer<S>) -> R)
		return schema.createSchema<<R, schema.InnerSchema<shared.shape<S>, shared.metadata<S>>>>(
			"transform",
			function(value)
				const sourceSchema: schema.AnySchema = sourceSchema

				const sourceSchemaParseResult = sourceSchema.parse(value)

				if not sourceSchemaParseResult.ok then
					return sourceSchemaParseResult
				end

				return result.parse.ok(transform(sourceSchemaParseResult.value))
			end,
			schema.innerSchema(sourceSchema)
		)
	end
end

return transformSchemaBuilder
