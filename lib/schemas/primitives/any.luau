const result = require("../../result")
const schema = require("../../schema")

const function anySchema(): schema.Schema<any>
	return schema<<any>>(function(value)
		return result.validate.ok()
	end)
end

return anySchema
