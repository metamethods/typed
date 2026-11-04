const core = require("@packages/engine")

const function neverSchemaBuilder()
	return core.schema.createSchema<<never, nil, nil>>("never", function(value)
		return core.parseResult.err({
			core.parseIssue.create("invalid_type", `expected never, got {typeof(value)}`),
		})
	end)
end

return neverSchemaBuilder
