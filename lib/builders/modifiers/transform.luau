const result = require("../../result")
const schema = require("../../schema")

const function transformSchemaBuilder<T, S, M>(innerSchema: schema.Schema<T, S, M>)
	return function<R>(transformFn: (T) -> R)
		return schema<<R, schema.Schema<T, S, M>>>("transform", function(value)
			const innerSchemaParseResult = innerSchema.parse(value)

			if not innerSchemaParseResult.ok then
				return innerSchemaParseResult
			end

			return result.parse.ok(transformFn(innerSchemaParseResult.value))
		end, innerSchema)
	end
end

return transformSchemaBuilder
