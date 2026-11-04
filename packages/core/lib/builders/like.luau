const engine = require("@packages/engine")

const function likeSchemaBuilder<T>(typeName: string)
	return engine.schema.createSchema<<T, nil, nil>>("is", function(value)
		if type(value) ~= typeName then
			return engine.parseResult.err({
				engine.parseIssue.create("invalid_type", `expected {typeName}, got {typeof(value)}.`),
			})
		end

		return engine.parseResult.ok(value)
	end)
end

return likeSchemaBuilder
