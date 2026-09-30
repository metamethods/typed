const result = require("@lib/result")
const issue = require("@lib/issue")
const schema = require("@lib/schema")
const shared = require("@lib/shared")

const function iterableSchemaBuilder<SK, SV>(keySchema: SK, valueSchema: SV)
	return schema.createSchema<<{ [shared.infer<SK>]: shared.infer<SV>? }, {
		key: schema.InnerSchema<shared.shape<SK>, shared.metadata<SK>>,
		value: schema.InnerSchema<shared.shape<SV>, shared.metadata<SV>>,
	}, nil>>("iterable", function(value)
		const keySchema: schema.SchemaFromGeneric<SK> = keySchema
		const valueSchema: schema.SchemaFromGeneric<SV> = valueSchema

		if type(value) ~= "table" then
			return result.parse.err({
				issue.parse.invalidType(`expected table, got {typeof(value)}`),
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
					table.insert(issues, issue.appendContext(validationIssue, `at index {index}: key`))
				end
			end

			if not valueValidateResult.ok then
				for _, validationIssue in valueValidateResult.issues do
					table.insert(issues, issue.appendContext(validationIssue, `at index {index}: value`))
				end
			end
		end

		if #issues > 0 then
			return result.parse.err(issues)
		end

		return result.parse.ok(value)
	end, {
		key = schema.innerSchema(keySchema),
		value = schema.innerSchema(valueSchema),
	})
end

return iterableSchemaBuilder
