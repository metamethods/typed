const shared = require("../../shared")
const result = require("../../result")
const issue = require("../../issue")
const schema = require("../../schema")

const function arraySchema<T>(innerSchema: T): schema.Schema<{ shared.infer<T> }, { shared.infer_parse<T> }>
	const innerSchema = innerSchema :: schema.Schema<shared.infer<T>, shared.infer_parse<T>>

	return schema<<{ shared.infer<T> }>>(function(value)
		if type(value) ~= "table" then
			return result.validate.err({
				issue.validate.invalidType(`expected table, got {typeof(value)}`),
			})
		end

		const issues = {}

		for index, value in value do
			if type(index) ~= "number" then
				return result.validate.err({
					issue.validate.invalidType(`expected index to be a number, got {typeof(index)}`),
				})
			end

			const validateResult = innerSchema.validate(value)

			if validateResult.ok then
				continue
			end

			for _, validationIssue in validateResult.issues do
				table.insert(issues, issue.appendContext(validationIssue, `at index {index}`))
			end
		end

		if #issues > 0 then
			return result.validate.err(issues)
		end

		return result.validate.ok()
	end)
end

return arraySchema
