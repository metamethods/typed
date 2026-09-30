const core = require("@packages/typed_core")

const function unknownSchemaBuilder()
	return core.schema.createSchema<<unknown, nil, nil>>("unknown", function(value)
		return core.parseResult.ok(value)
	end)
end

return unknownSchemaBuilder
