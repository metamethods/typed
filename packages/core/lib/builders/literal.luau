const engine = require("@packages/engine")

const function literalSchemaBuilder<T>(literal: T)
	return engine.schema.createSchema<<T, nil, nil>>("literal", function(value)
		if value ~= literal then
			return engine.parseResult.err({
				engine.parseIssue.create("invalid_value", `expected {literal}, got {value}`),
			})
		end

		return engine.parseResult.ok(value :: T)
	end)
end

return literalSchemaBuilder
