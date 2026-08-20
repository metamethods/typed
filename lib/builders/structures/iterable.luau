const result = require("../../result")
const issue = require("../../issue")
const schema = require("../../schema")

const function iterableSchemaBuilder<K, KS, KM, T, TS, TM>(keySchema: schema.Schema<K, KS, KM>, valueSchema: schema.Schema<T, TS, TM>)
	return schema<<{ [K]: T? }, { key: schema.Schema<K, KS, KM>, value: schema.Schema<T, TS, TM> }>>(
		"iterable",
		function(value)
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
		end,
		{
			key = keySchema,
			value = valueSchema,
		}
	)
end

return iterableSchemaBuilder
