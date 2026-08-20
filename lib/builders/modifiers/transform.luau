const result = require("../../result")
const schema = require("../../schema")

const function transformSchemaBuilder<T, S, M>(innerSchema: schema.Schema<T, S, M>)
	return function<R>(transformFn: (T) -> R)
		return schema<<R, nil>>("transform", function(value: T)
			return innerSchema.validate(value)
		end, function(value)
			-- the validate function should be ran before this when .parse is called
			-- if it does fail, this function shouldnt run
			-- therefore, we should be safe when using unwrapParse
			return result.parse.ok(transformFn(innerSchema.unwrapParse(value)))
		end)
	end
end

return transformSchemaBuilder
