const core = require("@packages/engine")

const function anySchemaBuilder()
	return core.schema.createSchema<<any, nil, nil>>("any", function(value)
		return core.parseResult.ok(value)
	end)
end

return anySchemaBuilder
