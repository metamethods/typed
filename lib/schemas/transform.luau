const shared = require("../shared")
const schema = require("../schema")

const function transformSchema<T>(innerSchema: T): <R>(transformFn: (shared.infer<T>) -> R) -> schema.Schema<R>
	const innerSchema = innerSchema :: schema.Schema<T>

	return function<R>(transformFn)
		return schema<<R>>(function(value)
			return innerSchema.validate(value)
		end, function(value: any)
			-- the validate function should be ran before this when .parse is called
			-- if it does fail, this function shouldnt run
			-- therefore, we should be safe when using unwrapParse
			return transformFn(innerSchema.unwrapParse(value))
		end)
	end
end

return transformSchema
