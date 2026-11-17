const engine = require("@packages/luau/engine")

const function iterableSchemaBuilder<SK, SV>(keySchema: SK, valueSchema: SV)
	return engine.schema.createSchema<<{ [engine.infer<SK>]: engine.infer<SV>? }, {
		key: engine.InnerSchema<engine.shape<SK>, engine.metadata<SK>>,
		value: engine.InnerSchema<engine.shape<SV>, engine.metadata<SV>>,
	}, nil>>("iterable", function(value)
		const keySchema: engine.SchemaFromGeneric<SK> = keySchema
		const valueSchema: engine.SchemaFromGeneric<SV> = valueSchema

		if type(value) ~= "table" then
			return engine.parseResult.err({
				engine.parseIssue.create("invalid_type", `expected table, got {typeof(value)}`),
			})
		end

		const issues = {}

		for index, value in value do
			const keyValidateResult = keySchema.parse(index)
			const valueValidateResult = valueSchema.parse(value)

			if keyValidateResult.ok and valueValidateResult.ok then
				continue
			end

			if not keyValidateResult.ok then
				for _, validationIssue in keyValidateResult.issues do
					table.insert(issues, engine.parseIssue.appendContext(validationIssue, `at index {index}: key`))
				end
			end

			if not valueValidateResult.ok then
				for _, validationIssue in valueValidateResult.issues do
					table.insert(issues, engine.parseIssue.appendContext(validationIssue, `at index {index}: value`))
				end
			end
		end

		if #issues > 0 then
			return engine.parseResult.err(issues)
		end

		return engine.parseResult.ok(value)
	end, {
		key = engine.schema.innerSchema(keySchema),
		value = engine.schema.innerSchema(valueSchema),
	})
end

return iterableSchemaBuilder
