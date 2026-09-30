const core = require("@packages/typed_core")

const function intersectSchemaBuilder<SA, SB>(sourceSchemaA: SA, sourceSchemaB: SB)
	return core.schema.createSchema<<core.infer<SA> & core.infer<SB>, {
		left: core.InnerSchema<core.shape<SA>, core.metadata<SA>>,
		right: core.InnerSchema<core.shape<SB>, core.metadata<SB>>,
	}, nil>>("intersect", function(value)
		const sourceSchemaA: core.SchemaFromGeneric<SA> = sourceSchemaA
		const sourceSchemaB: core.SchemaFromGeneric<SB> = sourceSchemaB

		const parseResult0 = sourceSchemaA.parse(value)

		if not parseResult0.ok then
			return parseResult0
		end

		const parseResult1 = sourceSchemaB.parse(value)

		if not parseResult1.ok then
			return parseResult1
		end

		if type(parseResult0.value) ~= "table" then
			return core.parseResult.err({
				core.parseIssue.create(
					"unmergeable_value",
					`unable to merge value; expected table, got {typeof(parseResult0.value)}`
				),
			})
		end

		if type(parseResult1.value) ~= "table" then
			return core.parseResult.err({
				core.parseIssue.create(
					"unmergeable_value",
					`unable to merge value; expected table, got {typeof(parseResult1.value)}`
				),
			})
		end

		const merged = parseResult0.value :: any

		for key, value in parseResult1.value :: any do
			if merged[key] then
				return core.parseResult.err({
					core.parseIssue.appendContext(
						core.parseIssue.create("key_conflict", `key conflict with {key}`),
						`{key}`
					),
				})
			end

			merged[key] = value
		end

		return core.parseResult.ok(merged)
	end, {
		left = core.schema.innerSchema(sourceSchemaA),
		right = core.schema.innerSchema(sourceSchemaB),
	})
end

return intersectSchemaBuilder
