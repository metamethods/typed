const engine = require("@packages/engine")

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
	return engine.schema.createSchema<<engine.infer<SA> | engine.infer<SB>, {
		left: engine.InnerSchema<engine.shape<SA>, engine.metadata<SA>>,
		right: engine.InnerSchema<engine.shape<SB>, engine.metadata<SB>>,
	}, nil>>("union", function(value)
		const sourceSchemaA: engine.SchemaFromGeneric<SA> = sourceSchemaA
		const sourceSchemaB: engine.SchemaFromGeneric<SB> = sourceSchemaB

		const result0 = sourceSchemaA.parse(value)

		if result0.ok then
			return result0
		end

		const result1 = sourceSchemaB.parse(value)

		if result1.ok then
			return result1
		end

		return engine.parseResult.err(joinArrays(result0.issues, result1.issues))
	end, {
		left = engine.schema.innerSchema(sourceSchemaA),
		right = engine.schema.innerSchema(sourceSchemaB),
	})
end

return unionSchema
