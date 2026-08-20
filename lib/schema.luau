const issue = require("./issue")
const result = require("./result")

const function schemaMeta<T, S, M, NewM>(self: Schema<T, S, M>, metadata: NewM): Schema<T, S, NewM>
	self.metadata = metadata
	return self
end

export type Schema<T, S = nil, M = nil> = {
	type: string,
	infer: T,
	metadata: M,
	shape: S,
	meta: typeof(schemaMeta),
	parse: (value: any) -> result.ParseResult<T>,
	unwrapParse: (value: any) -> T,
	cast: (value: T) -> T,
}

export type UnknownSchema = Schema<unknown, unknown, unknown>

export type AnySchema = Schema<any, any, any>

const function schema<T, S>(type: string, parse: (value: any) -> result.ParseResult<T>, shape: S?)
	return {
		type = type,
		shape = shape,
		meta = schemaMeta,
		parse = parse,
		unwrapParse = function(value)
			const parseResult = parse(value)
			if not parseResult.ok then
				error(issue.formatIssues(parseResult.issues))
			end
			return parseResult.value
		end,
		cast = function(value)
			return value
		end,
	} :: Schema<T, S>
end

return schema
