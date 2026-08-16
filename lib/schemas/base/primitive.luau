const result = require("../../result")
const issue = require("../../issue")
const schema = require("../../schema")

const function primitiveSchema<T>(typeName: string, validateFn: ((value: any) -> result.ValidateResult)?)
	return schema<<T>>(function(value)
		if type(value) ~= typeName then
			return result.validate.err({
				issue.validate.invalidType(`expected {typeName}, got {typeof(value)}`),
			})
		end

		if validateFn then
			return validateFn(value)
		end

		return result.validate.ok()
	end)
end

return primitiveSchema
