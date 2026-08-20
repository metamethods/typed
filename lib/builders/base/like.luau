const issue = require("../../issue")
const result = require("../../result")
local schema = require("../../schema")

const function likeSchemaBuilder<T>(typeName: string)
	return schema<<T, nil>>("is", function(value)
		if type(value) ~= typeName then
			return result.parse.err({
				issue.parse.invalidType(`expected {typeName}, got {typeof(value)}.`),
			})
		end

		return result.parse.ok(value :: T)
	end)
end

return likeSchemaBuilder
