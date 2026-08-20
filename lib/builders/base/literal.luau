const issue = require("../../issue")
const result = require("../../result")
const schema = require("../../schema")

const function literalSchemaBuilder<T>(literal: T)
	return schema<<T, nil>>("literal", function(value)
		if value ~= literal then
			return result.parse.err({
				issue.parse.invalidValue(`expected {literal}, got {value}`),
			})
		end

		return result.parse.ok(value :: T)
	end)
end

return literalSchemaBuilder
