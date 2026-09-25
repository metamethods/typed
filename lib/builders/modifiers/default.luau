const optional = require("./optional")
const transform = require("./transform")
const shared = require("../../shared")

const function defaultSchemaBuilder<S>(sourceSchema: S, defaultValue: shared.infer<S>)
	return transform(optional(sourceSchema))(function(value)
		if value == nil then
			return defaultValue
		end

		return value
	end)
end

return defaultSchemaBuilder
