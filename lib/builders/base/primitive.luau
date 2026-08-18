const result = require("../../result")
const issue = require("../../issue")
const schema = require("../../schema")

const function primitiveSchemaBuilder<T>(typeName: schema.SchemaType, validateFn: ((value: any) -> result.ValidateResult)?)
	return schema<<T, nil, nil>>(typeName, function(value)
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

return primitiveSchemaBuilder
