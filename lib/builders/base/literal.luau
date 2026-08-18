const issue = require("../../issue")
const result = require("../../result")
const schema = require("../../schema")

const function literalSchemaBuilder<T>(literal: T)
	return schema<<T, nil, nil>>(function(value)
		if literal == value then
			return result.validate.ok()
		end

		return result.validate.err({
			issue.validate.invalidValue(`expected ({typeof(literal)}) {literal}, got ({typeof(value)}) {value}`),
		})
	end)
end

return literalSchemaBuilder
