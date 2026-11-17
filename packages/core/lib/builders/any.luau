const engine = require("@packages/luau/engine")

const function anySchemaBuilder()
	return engine.schema.createSchema<<any, nil, nil>>("any", function(value)
		return engine.parseResult.ok(value)
	end)
end

return anySchemaBuilder
