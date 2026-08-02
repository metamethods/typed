const result = require("../result")
const shared = require("../shared")
const schema = require("../schema")

const function transformSchema<T>(
	innerSchema: T
): <R>(transformFn: (shared.infer_parse<T>) -> R) -> schema.Schema<shared.infer<T>, R>
	return function<R>(transformFn)
		const innerSchema = innerSchema :: schema.Schema<shared.infer<T>, R>

		return schema<<shared.infer<T>, R>>(function(value: shared.infer<T>)
			return innerSchema.validate(value)
		end, function(value: any)
			-- the validate function should be ran before this when .parse is called
			-- if it does fail, this function shouldnt run
			-- therefore, we should be safe when using unwrapParse
			return result.parse.ok(transformFn(innerSchema.unwrapParse(value)))
		end)
	end
end

return transformSchema
