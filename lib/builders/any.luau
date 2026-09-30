const result = require("@lib/result")
const schema = require("@lib/schema")

const function anySchemaBuilder()
	return schema.createSchema<<any, nil, nil>>("any", function(value)
		return result.parse.ok(value)
	end)
end

return anySchemaBuilder
