const result = require("../../result")
const schema = require("../../schema")

const function unknownSchemaBuilder()
	return schema.createSchema<<unknown, nil, nil>>("unknown", function(value)
		return result.parse.ok(value)
	end)
end

return unknownSchemaBuilder
