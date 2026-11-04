const parseIssue = require("@self/parseIssue")
const parseResult = require("@self/parseResult")
const schema = require("@self/schema")

export type infer<T> = schema.infer<T>

export type shape<T> = schema.shape<T>

export type metadata<T> = schema.metadata<T>

export type Schema<T, S = nil, M = nil> = schema.Schema<T, S, M>

export type InnerSchema<S = nil, M = nil> = schema.InnerSchema<S, M>

export type UnknownSchema = schema.UnknownSchema

export type AnySchema = schema.AnySchema

export type SchemaFromGeneric<S> = schema.SchemaFromGeneric<S>

export type SchemaShape<S, M = any> = schema.Schema<any, S, M>

export type ParseIssue = parseIssue.ParseIssue

export type ParseResult<T> = parseResult.ParseResult<T>

export type ParseResultOk<T> = parseResult.ParseResultOk<T>

export type ParseResultErr = parseResult.ParseResultErr

return {
	parseIssue = parseIssue,
	parseResult = parseResult,
	schema = schema,
}
