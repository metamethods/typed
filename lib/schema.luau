const issue = require("./issue")
const result = require("./result")

export type Schema<T> = {
	_infer: T,
	validate: (value: any) -> result.ValidateResult,
	parse: (value: any) -> result.ParseResult<T>,
	parseCast: <C>(value: any) -> result.ParseResult<C>,
	unwrapParse: (value: any) -> T,
	enforce: (value: T) -> T,
	optional: boolean?,
}

const function schema<T>(
	validateFn: (value: any) -> result.ValidateResult,
	parseFn: ((value: any) -> result.ParseResult<T>)?
): Schema<T>
	const schemaValidateFn = function(value: any): result.ValidateResult
		return validateFn(value)
	end

	const schemaParseFn = function(value: any): result.ParseResult<T>
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
		parseCast = function<C>(value: any)
			return schemaParseFn(value) :: result.ParseResult<C>
		end,
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
	} :: Schema<T>
end

return schema
