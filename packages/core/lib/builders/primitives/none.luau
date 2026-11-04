const engine = require("@packages/engine")

const function noneSchemaBuilder()
	return engine.schema.createSchema<<nil, nil, nil>>("none", function(value)
		if value ~= nil then
			return engine.parseResult.err({
				engine.parseIssue.create("invalid_type", `expected never, got {typeof(value)}`),
			})
		end

		return engine.parseResult.ok(value)
	end)
end

return noneSchemaBuilder
