const issue = require("../../issue")
const result = require("../../result")
const schema = require("../../schema")

const function intersectSchemaBuilder<T0, T0S, T0M, T1, T1S, T1M>(schemaA: schema.Schema<T0, T0S, T0M>, schemaB: schema.Schema<T1, T1S, T1M>)
	return schema<<T0 & T1, { left: schema.Schema<T0, T0S, T0M>, right: schema.Schema<T1, T1S, T1M> }>>(
		"intersect",
		function(value)
			const parseResult0 = schemaA.parse(value)

			if not parseResult0.ok then
				return parseResult0
			end

			const parseResult1 = schemaB.parse(value)

			if not parseResult1.ok then
				return parseResult1
			end

			if type(parseResult0.value) ~= "table" then
				return result.parse.err({
					issue.parse.unmergeableValue(
						`unable to merge value; expected table, got {typeof(parseResult0.value)}`
					),
				})
			end

			if type(parseResult1.value) ~= "table" then
				return result.parse.err({
					issue.parse.unmergeableValue(
						`unable to merge value; expected table, got {typeof(parseResult1.value)}`
					),
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
		end,
		{
			left = schemaA,
			right = schemaB,
		}
	)
end

return intersectSchemaBuilder
