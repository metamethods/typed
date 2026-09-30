const issue = require("@lib/issue")
const result = require("@lib/result")
const schema = require("@lib/schema")

const function neverSchemaBuilder()
	return schema.createSchema<<never, nil, nil>>("never", function(value)
		return result.parse.err({ issue.parse.invalidType(`expected never, got {typeof(value)}`) })
	end)
end

return neverSchemaBuilder
