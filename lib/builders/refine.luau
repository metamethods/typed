const issue = require("@lib/issue")
const result = require("@lib/result")
const schema = require("@lib/schema")
const shared = require("@lib/shared")

type RefineResult<T> = {
	ok: () -> result.ParseResultOk<T>,
	err: (message: string) -> result.ParseResultErr,
}

const function refineSchemaBuilder<S>(sourceSchema: S)
	const sourceSchema: schema.SchemaFromGeneric<S> = sourceSchema

	return function(refineFn: (
		value: shared.infer<S>,
		result: RefineResult<shared.infer<S>>
	) -> result.ParseResult<shared.infer<S>>)
		return schema.createSchema<<shared.infer<S>, schema.InnerSchema<shared.shape<S>, shared.metadata<S>>>>(
			"refine",
			function(value)
				const sourceSchemaParseResult = sourceSchema.parse(value)

				if not sourceSchemaParseResult.ok then
					return sourceSchemaParseResult
				end

				return refineFn(sourceSchemaParseResult.value, {
					ok = function()
						return result.parse.ok(sourceSchemaParseResult.value)
					end,
					err = function(message)
						return result.parse.err({
							issue.parse.refineError(message),
						})
					end,
				})
			end,
			schema.innerSchema(sourceSchema),
			sourceSchema.metadata
		)
	end
end

return refineSchemaBuilder
