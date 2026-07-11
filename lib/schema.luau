const issue = require("./issue")
const result = require("./result")

export type Schema<T> = {
	_infer: T,
	validate: (value: any) -> result.ValidateResult,
	parse: (value: any) -> result.ParseResult<T>,
	unwrapParse: (value: any) -> T,
	-- hi
	enforce: (value: T) -> T,
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
