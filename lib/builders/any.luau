const result = require("../result")
const schema = require("../schema")

const function anySchemaBuilder()
	return schema.createSchema<<any, nil, nil>>("any", function(value)
		return result.parse.ok(value)
	end)
end

return anySchemaBuilder
