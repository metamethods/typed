const result = require("../../result")
const schema = require("../../schema")

const function unknownSchemaBuilder()
	return schema<<unknown, nil>>("unknown", function(value)
		return result.parse.ok(value)
	end)
end

return unknownSchemaBuilder
