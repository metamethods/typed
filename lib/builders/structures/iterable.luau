const result = require("../../result")
const issue = require("../../issue")
const schema = require("../../schema")

const function iterableSchemaBuilder<K, KS, KM, T, TS, TM>(keySchema: schema.Schema<K, KS, KM>, valueSchema: schema.Schema<T, TS, TM>)
	return schema<<{ [K]: T? }>>(
		function(value)
			if type(value) ~= "table" then
				return result.validate.err({
					issue.validate.invalidType(`expected table, got {typeof(value)}`),
				})
			end

			const issues = {}

			for index, value in value do
				const keyValidateResult = keySchema.validate(index)
				const valueValidateResult = valueSchema.validate(value)

				if keyValidateResult.ok and valueValidateResult.ok then
					continue
				end

				if not keyValidateResult.ok then
					for _, validationIssue in keyValidateResult.issues do
						table.insert(issues, issue.appendContext(validationIssue, `at index {index}'s key`))
					end
				end

				if not valueValidateResult.ok then
					for _, validationIssue in valueValidateResult.issues do
						table.insert(issues, issue.appendContext(validationIssue, `at index {index}'s value`))
					end
				end
			end

			if #issues > 0 then
				return result.validate.err(issues)
			end

			return result.validate.ok()
		end,
		nil,
		{
			key = keySchema,
			value = valueSchema,
		}
	)
end

return iterableSchemaBuilder
