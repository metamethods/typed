const result = require("../../result")
const schema = require("../../schema")

const function unknownSchema()
	return schema<<unknown>>(function(value)
		return result.validate.ok()
	end)
end

return unknownSchema
