const issue = require("../../issue")
const result = require("../../result")
const schema = require("../../schema")

const function neverSchemaBuilder()
	return schema<<never, nil>>("never", function(value)
		return result.parse.err({ issue.parse.invalidType(`expected never, got {typeof(value)}`) })
	end)
end

return neverSchemaBuilder
