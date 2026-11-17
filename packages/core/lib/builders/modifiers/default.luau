const optional = require("./optional")
const transform = require("./transform")
const engine = require("@packages/luau/engine")

const function defaultSchemaBuilder<S>(sourceSchema: S, defaultValue: engine.infer<S>)
	return transform(optional(sourceSchema))(function(value)
		if value == nil then
			return defaultValue
		end

		return value
	end)
end

return defaultSchemaBuilder
