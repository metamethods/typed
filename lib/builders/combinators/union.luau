const issue = require("../../issue")
const result = require("../../result")
const schema = require("../../schema")

const function unionSchema<T0, T0S, T0M, T1, T1S, T1M>(schemaA: schema.Schema<T0, T0S, T0M>, schemaB: schema.Schema<T1, T1S, T1M>)
	return schema<<T0 | T1, { left: schema.Schema<T0, T0S, T0M>, right: schema.Schema<T1, T1S, T1M> }>>(
		"union",
		function(value)
			const parseResult0 = schemaA.parse(value)

			if parseResult0.ok then
				return parseResult0
			end

			const parseResult1 = schemaB.parse(value)

			if parseResult1.ok then
				return parseResult1
			end

			return result.parse.err({
				issue.parse.invalidUnion("invalid input"),
			})
		end,
		{
			left = schemaA,
			right = schemaB,
		}
	)
end

return unionSchema
