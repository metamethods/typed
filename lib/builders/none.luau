const result = require("@lib/result")
const schema = require("@lib/schema")
const issue = require("@lib/issue")

const function noneSchemaBuilder()
	return schema.createSchema<<nil, nil, nil>>("none", function(value)
		if value ~= nil then
			return result.parse.err({ issue.parse.invalidType(`expected never, got {typeof(value)}`) })
		end

		return result.parse.ok(value)
	end)
end

return noneSchemaBuilder
