const result = require("../../result")
const schema = require("../../schema")
const shared = require("../../shared")

const function unionSchema<SA, SB>(sourceSchemaA: SA, sourceSchemaB: SB)
	return schema.createSchema<<shared.infer<SA> | shared.infer<SB>, {
		left: schema.InnerSchema<shared.shape<SA>, shared.metadata<SA>>,
		right: schema.InnerSchema<shared.shape<SB>, shared.metadata<SB>>,
	}>>("union", function(value)
		const sourceSchemaA: schema.AnySchema = sourceSchemaA
		const sourceSchemaB: schema.AnySchema = sourceSchemaB

		const parseResult0 = sourceSchemaA.parse(value)

		if parseResult0.ok then
			return parseResult0
		end

		const parseResult1 = sourceSchemaB.parse(value)

		if parseResult1.ok then
			return parseResult1
		end

		return result.parse.err(shared.joinArrays(parseResult0.issues, parseResult1.issues))
	end, {
		left = schema.innerSchema(sourceSchemaA),
		right = schema.innerSchema(sourceSchemaB),
	})
end

return unionSchema
