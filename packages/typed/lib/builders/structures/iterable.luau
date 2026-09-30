const core = require("@packages/typed_core")

const function iterableSchemaBuilder<SK, SV>(keySchema: SK, valueSchema: SV)
	return core.schema.createSchema<<{ [core.infer<SK>]: core.infer<SV>? }, {
		key: core.InnerSchema<core.shape<SK>, core.metadata<SK>>,
		value: core.InnerSchema<core.shape<SV>, core.metadata<SV>>,
	}, nil>>("iterable", function(value)
		const keySchema: core.SchemaFromGeneric<SK> = keySchema
		const valueSchema: core.SchemaFromGeneric<SV> = valueSchema

		if type(value) ~= "table" then
			return core.parseResult.err({
				core.parseIssue.create("invalid_type", `expected table, got {typeof(value)}`),
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
					table.insert(issues, core.parseIssue.appendContext(validationIssue, `at index {index}: key`))
				end
			end

			if not valueValidateResult.ok then
				for _, validationIssue in valueValidateResult.issues do
					table.insert(issues, core.parseIssue.appendContext(validationIssue, `at index {index}: value`))
				end
			end
		end

		if #issues > 0 then
			return core.parseResult.err(issues)
		end

		return core.parseResult.ok(value)
	end, {
		key = core.schema.innerSchema(keySchema),
		value = core.schema.innerSchema(valueSchema),
	})
end

return iterableSchemaBuilder
