const engine = require("@packages/luau/engine")

const function isSchemaBuilder<T>(typeName: string)
	return engine.schema.createSchema<<T, nil, nil>>("is", function(value)
		if typeof(value) ~= typeName then
			return engine.parseResult.err({
				engine.parseIssue.create("invalid_type", `expected {typeName}, got {typeof(value)}.`),
			})
		end

		return engine.parseResult.ok(value :: T)
	end)
end

return isSchemaBuilder
