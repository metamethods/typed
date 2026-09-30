const core = require("@packages/typed_core")

const function isSchemaBuilder<T>(typeName: string)
	return core.schema.createSchema<<T, nil, nil>>("is", function(value)
		if typeof(value) ~= typeName then
			return core.parseResult.err({
				core.parseIssue.create("invalid_type", `expected {typeName}, got {typeof(value)}.`),
			})
		end

		return core.parseResult.ok(value :: T)
	end)
end

return isSchemaBuilder
