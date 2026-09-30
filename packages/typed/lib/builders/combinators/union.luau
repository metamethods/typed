const core = require("@packages/typed_core")

const function joinArrays<T>(...: { T }): { T }
	const result = {}

	for _, array in { ... } do
		for _, value in array do
			table.insert(result, value)
		end
	end

	return result
end

const function unionSchema<SA, SB>(sourceSchemaA: SA, sourceSchemaB: SB)
	return core.schema.createSchema<<core.infer<SA> | core.infer<SB>, {
		left: core.InnerSchema<core.shape<SA>, core.metadata<SA>>,
		right: core.InnerSchema<core.shape<SB>, core.metadata<SB>>,
	}, nil>>("union", function(value)
		const sourceSchemaA: core.SchemaFromGeneric<SA> = sourceSchemaA
		const sourceSchemaB: core.SchemaFromGeneric<SB> = sourceSchemaB

		const result0 = sourceSchemaA.parse(value)

		if result0.ok then
			return result0
		end

		const result1 = sourceSchemaB.parse(value)

		if result1.ok then
			return result1
		end

		return core.parseResult.err(joinArrays(result0.issues, result1.issues))
	end, {
		left = core.schema.innerSchema(sourceSchemaA),
		right = core.schema.innerSchema(sourceSchemaB),
	})
end

return unionSchema
