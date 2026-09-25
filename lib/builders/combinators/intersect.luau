const issue = require("../../issue")
const result = require("../../result")
const schema = require("../../schema")
const shared = require("../../shared")

const function intersectSchemaBuilder<SA, SB>(sourceSchemaA: SA, sourceSchemaB: SB)
	return schema.createSchema<<shared.infer<SA> & shared.infer<SB>, {
		left: schema.InnerSchema<shared.shape<SA>, shared.metadata<SA>>,
		right: schema.InnerSchema<shared.shape<SB>, shared.metadata<SB>>,
	}>>("intersect", function(value)
		const sourceSchemaA: schema.AnySchema = sourceSchemaA
		const sourceSchemaB: schema.AnySchema = sourceSchemaB

		const parseResult0 = sourceSchemaA.parse(value)

		if not parseResult0.ok then
			return parseResult0
		end

		const parseResult1 = sourceSchemaB.parse(value)

		if not parseResult1.ok then
			return parseResult1
		end

		if type(parseResult0.value) ~= "table" then
			return result.parse.err({
				issue.parse.unmergeableValue(`unable to merge value; expected table, got {typeof(parseResult0.value)}`),
			})
		end

		if type(parseResult1.value) ~= "table" then
			return result.parse.err({
				issue.parse.unmergeableValue(`unable to merge value; expected table, got {typeof(parseResult1.value)}`),
			})
		end

		const merged = parseResult0.value :: any

		for key, value in parseResult1.value :: any do
			if merged[key] then
				return result.parse.err({
					issue.appendContext(issue.parse.keyConflict(`key conflict with {key}`), `{key}`),
				})
			end

			merged[key] = value
		end

		return result.parse.ok(merged)
	end, {
		left = schema.innerSchema(sourceSchemaA),
		right = schema.innerSchema(sourceSchemaB),
	})
end

return intersectSchemaBuilder
