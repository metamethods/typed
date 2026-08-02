const issue = require("./issue")
const result = require("./result")

export type Schema<T, P> = {
	_infer: T,
	_inferParse: P,
	validate: (value: any) -> result.ValidateResult,
	parse: (value: any) -> result.ParseResult<P>,
	unwrapParse: (value: any) -> P,
	enforce: (value: T) -> T,
	optional: boolean?,
}

const function schema<T, P>(
	validateFn: (value: any) -> result.ValidateResult,
	parseFn: ((value: any) -> result.ParseResult<P>)?
): Schema<T, P>
	const schemaValidateFn = function(value: any): result.ValidateResult
		return validateFn(value)
	end

	const schemaParseFn = function(value: any): result.ParseResult<P>
		const validateResult = schemaValidateFn(value)

		if not validateResult.ok then
			return result.parse.err({
				issue.parse.validateFailed(validateResult.issues),
			})
		end

		if parseFn then
			return parseFn(value)
		else
			return result.parse.ok(value)
		end
	end

	return {
		validate = schemaValidateFn,
		parse = schemaParseFn,
		unwrapParse = function(value)
			const parseResult = schemaParseFn(value)
			if not parseResult.ok then
				error(issue.formatIssues(parseResult.issues))
			end
			return parseResult.value
		end,
		enforce = function(value)
			return value
		end,
	} :: Schema<T, P>
end

return schema
