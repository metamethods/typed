const core = require("@packages/typed_core")

const function literalSchemaBuilder<T>(literal: T)
	return core.schema.createSchema<<T, nil, nil>>("literal", function(value)
		if value ~= literal then
			return core.parseResult.err({
				core.parseIssue.create("invalid_value", `expected {literal}, got {value}`),
			})
		end

		return core.parseResult.ok(value :: T)
	end)
end

return literalSchemaBuilder
