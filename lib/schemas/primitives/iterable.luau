const shared = require("../../shared")
const result = require("../../result")
const issue = require("../../issue")
const schema = require("../../schema")

const function arraySchema<T0, T1>(keySchema: T0, valueSchema: T1): schema.Schema<{ [shared.infer<T0>]: shared.infer<T1> }>
	const keySchema = keySchema :: schema.Schema<T0>
	const valueSchema = valueSchema :: schema.Schema<T1>

	return schema<<{ [shared.infer<T0>]: shared.infer<T1> }>>(function(value)
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
					table.insert(issues, issue.appendContext(validationIssue, `at index {index}`))
				end
			end

			if not valueValidateResult.ok then
				for _, validationIssue in valueValidateResult.issues do
					table.insert(issues, issue.appendContext(validationIssue, `at index {index}`))
				end
			end
		end

		if #issues > 0 then
			return result.validate.err(issues)
		end

		return result.validate.ok()
	end)
end

return arraySchema
