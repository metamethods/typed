const issue = require("./issue")
const result = require("./result")

const function schemaMeta<T, S, M, NewM>(self: Schema<T, S, M>, metadata: NewM): Schema<T, S, NewM>
	self.metadata = metadata
	return self
end

export type SchemaType =
	"table"
	| "iterable"
	| "transform"
	| "union"
	| "intersect"
	| "string"
	| "number"
	| "boolean"
	| "nil"
	| "vector"
	| "buffer"
	| "function"
	| "userdata"
	| "unknown"
	| "never"
	| "any"
	| "literal"

export type Schema<T, S = nil, M = nil> = {
	type: SchemaType,
	infer: T,
	metadata: M,
	shape: S,
	meta: typeof(schemaMeta),
	validate: (value: any) -> result.ValidateResult,
	parse: (value: any) -> result.ParseResult<T>,
	unwrapParse: (value: any) -> T,
	enforce: (value: T) -> T,
}

export type UnknownSchema = Schema<unknown, unknown, unknown>

const function schema<T, S, M>(
	type: SchemaType,
	validateFn: (value: any) -> result.ValidateResult,
	parseFn: ((value: any) -> result.ParseResult<T>)?,
	shape: S?
): Schema<T, S, M>
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
		type = type,
		shape = shape,
		meta = schemaMeta,
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
	} :: Schema<T, S, M>
end

return schema
