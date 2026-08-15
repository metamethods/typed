const result = require("../../result")
const shared = require("../../shared")
const schema = require("../../schema")

const function transformSchema<T>(innerSchema: T)
	const innerSchema = innerSchema :: schema.Schema<shared.infer<T>>

	return function<R>(transformFn: (shared.infer<T>) -> R)
		return schema<<R>>(function(value: shared.infer<T>)
			return innerSchema.validate(value)
		end, function(value)
			-- the validate function should be ran before this when .parse is called
			-- if it does fail, this function shouldnt run
			-- therefore, we should be safe when using unwrapParse
			return result.parse.ok(transformFn(innerSchema.unwrapParse(value)))
		end)
	end
end

return transformSchema
