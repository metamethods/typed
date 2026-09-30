const core = require("@packages/typed_core")

const function anySchemaBuilder()
	return core.schema.createSchema<<any, nil, nil>>("any", function(value)
		return core.parseResult.ok(value)
	end)
end

return anySchemaBuilder
