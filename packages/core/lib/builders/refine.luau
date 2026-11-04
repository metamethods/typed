const engine = require("@packages/engine")

type RefineResult<T> = {
	ok: () -> engine.ParseResultOk<T>,
	err: (message: string) -> engine.ParseResultErr,
}

const function refineSchemaBuilder<S>(sourceSchema: S)
	const sourceSchema: engine.SchemaFromGeneric<S> = sourceSchema

	return function(refineFn: (
		value: engine.infer<S>,
		result: RefineResult<engine.infer<S>>
	) -> engine.ParseResult<engine.infer<S>>)
		return engine.schema.createSchema<<engine.infer<S>, engine.InnerSchema<engine.shape<S>, engine.metadata<S>>>>(
			"refine",
			function(value)
				const sourceSchemaParseResult = sourceSchema.parse(value)

				if not sourceSchemaParseResult.ok then
					return sourceSchemaParseResult
				end

				return refineFn(sourceSchemaParseResult.value, {
					ok = function()
						return engine.parseResult.ok(sourceSchemaParseResult.value)
					end,
					err = function(message)
						return engine.parseResult.err({
							engine.parseIssue.create("refine_error", message),
						})
					end,
				})
			end,
			engine.schema.innerSchema(sourceSchema),
			sourceSchema.metadata
		)
	end
end

return refineSchemaBuilder
