local shared = require(script.Parent.shared)
const issue = require("./issue")
const result = require("./result")

export type InnerSchema<S = nil, M = nil> = {
	type: string,
	shape: S,
	metadata: M,
}

export type Schema<T, S = nil, M = nil> = {
	type: string,
	infer: T,
	shape: S,
	metadata: M,
	parse: (value: any) -> result.ParseResult<T>,
	unwrapParse: (value: any) -> T,
	cast: (value: T) -> T,
}

export type UnknownSchema = Schema<unknown, unknown, unknown>

export type AnySchema = Schema<any, any, any>

const function createSchema<T, S>(type: string, parse: (value: any) -> result.ParseResult<T>, shape: S?)
	return {
		type = type,
		shape = shape,
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

const function innerSchema<S>(sourceSchema: S): InnerSchema<shared.shape<S>, shared.metadata<S>>
	const sourceSchema: AnySchema = sourceSchema

	return {
		type = sourceSchema.type,
		metadata = sourceSchema.metadata,
		shape = sourceSchema.shape,
	}
end

return {
	createSchema = createSchema,
	innerSchema = innerSchema,
}
