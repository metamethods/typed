const result = require("../../result")
const schema = require("../../schema")

const function anySchemaBuilder()
	return schema<<any, nil, nil>>(function(value)
		return result.validate.ok()
	end)
end

return anySchemaBuilder
