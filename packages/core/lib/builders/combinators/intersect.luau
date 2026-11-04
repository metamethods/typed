const engine = require("@packages/engine")

const function intersectSchemaBuilder<SA, SB>(sourceSchemaA: SA, sourceSchemaB: SB)
	return engine.schema.createSchema<<engine.infer<SA> & engine.infer<SB>, {
		left: engine.InnerSchema<engine.shape<SA>, engine.metadata<SA>>,
		right: engine.InnerSchema<engine.shape<SB>, engine.metadata<SB>>,
	}, nil>>("intersect", function(value)
		const sourceSchemaA: engine.SchemaFromGeneric<SA> = sourceSchemaA
		const sourceSchemaB: engine.SchemaFromGeneric<SB> = sourceSchemaB

		const parseResult0 = sourceSchemaA.parse(value)

		if not parseResult0.ok then
			return parseResult0
		end

		const parseResult1 = sourceSchemaB.parse(value)

		if not parseResult1.ok then
			return parseResult1
		end

		if type(parseResult0.value) ~= "table" then
			return engine.parseResult.err({
				engine.parseIssue.create(
					"unmergeable_value",
					`unable to merge value; expected table, got {typeof(parseResult0.value)}`
				),
			})
		end

		if type(parseResult1.value) ~= "table" then
			return engine.parseResult.err({
				engine.parseIssue.create(
					"unmergeable_value",
					`unable to merge value; expected table, got {typeof(parseResult1.value)}`
				),
			})
		end

		const merged = parseResult0.value :: any

		for key, value in parseResult1.value :: any do
			if merged[key] then
				return engine.parseResult.err({
					engine.parseIssue.appendContext(
						engine.parseIssue.create("key_conflict", `key conflict with {key}`),
						`{key}`
					),
				})
			end

			merged[key] = value
		end

		return engine.parseResult.ok(merged)
	end, {
		left = engine.schema.innerSchema(sourceSchemaA),
		right = engine.schema.innerSchema(sourceSchemaB),
	})
end

return intersectSchemaBuilder
