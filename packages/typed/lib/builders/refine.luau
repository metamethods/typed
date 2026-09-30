const core = require("@packages/typed_core")

type RefineResult<T> = {
	ok: () -> core.ParseResultOk<T>,
	err: (message: string) -> core.ParseResultErr,
}

const function refineSchemaBuilder<S>(sourceSchema: S)
	const sourceSchema: core.SchemaFromGeneric<S> = sourceSchema

	return function(
		refineFn: (
			value: core.infer<S>,
			result: RefineResult<core.infer<S>>
		) -> core.ParseResult<core.infer<S>>
	)
		return core.schema.createSchema<<core.infer<S>, core.InnerSchema<core.shape<S>, core.metadata<S>>>>(
			"refine",
			function(value)
				const sourceSchemaParseResult = sourceSchema.parse(value)

				if not sourceSchemaParseResult.ok then
					return sourceSchemaParseResult
				end

				return refineFn(sourceSchemaParseResult.value, {
					ok = function()
						return core.parseResult.ok(sourceSchemaParseResult.value)
					end,
					err = function(message)
						return core.parseResult.err({
							core.parseIssue.create("refine_error", message),
						})
					end,
				})
			end,
			core.schema.innerSchema(sourceSchema),
			sourceSchema.metadata
		)
	end
end

return refineSchemaBuilder
