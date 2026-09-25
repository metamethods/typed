const issue = require("../../issue")
const result = require("../../result")
const schema = require("../../schema")
const shared = require("../../shared")

type RefineResult<T> = {
	ok: () -> result.ParseResultOk<T>,
	err: (message: string) -> result.ParseResultErr,
}

const function refineSchemaBuilder<S>(sourceSchema: S)
	return function(refineFn: (
		value: shared.infer<S>,
		result: RefineResult<shared.infer<S>>
	) -> result.ParseResult<shared.infer<S>>)
		return schema.createSchema<<shared.infer<S>, schema.InnerSchema<shared.shape<S>, shared.metadata<S>>>>(
			"refine",
			function(value)
				const sourceSchema: schema.AnySchema = sourceSchema

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
			schema.innerSchema(sourceSchema)
		)
	end
end

return refineSchemaBuilder
