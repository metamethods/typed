const issue = require("../issue")
const result = require("../result")
const schema = require("../schema")

const function literalSchema<T>(literal: T): schema.Schema<T, T>
	return schema<<T, T>>(function(value)
		if literal == value then
			return result.validate.ok()
		end

		return result.validate.err({
			issue.validate.invalidValue(`expected ({typeof(literal)}) {literal}, got ({typeof(value)}) {value}`),
		})
	end)
end

return literalSchema
