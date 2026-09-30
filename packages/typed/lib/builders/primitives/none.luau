const core = require("@packages/typed_core")

const function noneSchemaBuilder()
	return core.schema.createSchema<<nil, nil, nil>>("none", function(value)
		if value ~= nil then
			return core.parseResult.err({
				core.parseIssue.create("invalid_type", `expected never, got {typeof(value)}`),
			})
		end

		return core.parseResult.ok(value)
	end)
end

return noneSchemaBuilder
