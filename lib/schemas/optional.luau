const shared = require("../shared")
const result = require("../result")
const schema = require("../schema")

const function optionalSchema<T>(innerSchema: T): schema.Schema<shared.infer<T>?>
	const innerSchema = innerSchema :: schema.Schema<T>

	return schema<<shared.infer<T>?>>(function(value)
		if value == nil then
			return result.validate.ok()
		else
			return innerSchema.validate(value)
		end
	end, function(value)
		return innerSchema.parse(value)
	end)
end

return optionalSchema
