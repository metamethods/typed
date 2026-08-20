const issue = require("../../issue")
const result = require("../../result")
const schema = require("../../schema")

type RefineResult<T> = {
	ok: () -> result.ParseResultOk<T>,
	err: (message: string) -> result.ParseResultErr,
}

const function refineSchemaBuilder<T, S, M>(innerSchema: schema.Schema<T, S, M>)
	return function(refineFn: (value: T, result: RefineResult<T>) -> result.ParseResult<T>)
		return schema<<T, schema.Schema<T, S, M>>>("refine", function(value)
			const innerSchemaParseResult = innerSchema.parse(value)

			if not innerSchemaParseResult.ok then
				return innerSchemaParseResult
			end

			return refineFn(innerSchemaParseResult.value, {
				ok = function()
					return result.parse.ok(innerSchemaParseResult.value)
				end,
				err = function(message)
					return result.parse.err({
						issue.parse.refineError(message),
					})
				end,
			})
		end, innerSchema)
	end
end

return refineSchemaBuilder
