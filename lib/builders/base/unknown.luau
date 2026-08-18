const result = require("../../result")
const schema = require("../../schema")

const function unknownSchemaBuilder()
	return schema<<unknown, nil, nil>>(function(value)
		return result.validate.ok()
	end)
end

return unknownSchemaBuilder
