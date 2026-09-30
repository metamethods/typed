const optional = require("./optional")
const transform = require("./transform")
const core = require("@packages/typed_core")

const function defaultSchemaBuilder<S>(sourceSchema: S, defaultValue: core.infer<S>)
	return transform(optional(sourceSchema))(function(value)
		if value == nil then
			return defaultValue
		end

		return value
	end)
end

return defaultSchemaBuilder
