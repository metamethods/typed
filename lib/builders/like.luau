const issue = require("@lib/issue")
const result = require("@lib/result")
local schema = require("@lib/schema")

const function likeSchemaBuilder<T>(typeName: string)
	return schema.createSchema<<T, nil, nil>>("is", function(value)
		if type(value) ~= typeName then
			return result.parse.err({
				issue.parse.invalidType(`expected {typeName}, got {typeof(value)}.`),
			})
		end

		return result.parse.ok(value)
	end)
end

return likeSchemaBuilder
