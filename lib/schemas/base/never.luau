const issue = require("../../issue")
const result = require("../../result")
const schema = require("../../schema")

const function neverSchema()
	return schema<<never>>(function(value)
		return result.validate.err({ issue.validate.invalidType(`expected never, got {typeof(value)}`) })
	end)
end

return neverSchema
