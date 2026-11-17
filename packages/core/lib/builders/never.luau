const engine = require("@packages/luau/engine")

const function neverSchemaBuilder()
	return engine.schema.createSchema<<never, nil, nil>>("never", function(value)
		return engine.parseResult.err({
			engine.parseIssue.create("invalid_type", `expected never, got {typeof(value)}`),
		})
	end)
end

return neverSchemaBuilder
