const issue = require("@lib/issue")
const result = require("@lib/result")
local schema = require("@lib/schema")

const function isSchemaBuilder<T>(typeName: string)
	return schema.createSchema<<T, nil, nil>>("is", function(value)
		if typeof(value) ~= typeName then
			return result.parse.err({
				issue.parse.invalidType(`expected {typeName}, got {typeof(value)}.`),
			})
		end

		return result.parse.ok(value :: T)
	end)
end

return isSchemaBuilder
