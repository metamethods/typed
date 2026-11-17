const engine = require("@packages/luau/engine")

const function unknownSchemaBuilder()
	return engine.schema.createSchema<<unknown, nil, nil>>("unknown", function(value)
		return engine.parseResult.ok(value)
	end)
end

return unknownSchemaBuilder
