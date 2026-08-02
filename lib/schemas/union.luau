const issue = require("../issue")
const shared = require("../shared")
const result = require("../result")
const schema = require("../schema")

const function unionSchema<T0, T1>(
	schemaA: T0,
	schemaB: T1
): schema.Schema<
	shared.infer<T0> | shared.infer<T1>,
	shared.infer_parse<T0> | shared.infer_parse<T1>
>
	const schemaA = schemaA :: schema.Schema<shared.infer<T0>, shared.infer_parse<T0>>
	const schemaB = schemaB :: schema.Schema<shared.infer<T1>, shared.infer_parse<T1>>

	return schema<<shared.infer<T0> | shared.infer<T1>, shared.infer_parse<T0> | shared.infer_parse<T1>>>(
		function(value)
			const validateResult0 = schemaA.validate(value)

			if validateResult0.ok then
				return result.validate.ok()
			end

			const validateResult1 = schemaB.validate(value)

			if validateResult1.ok then
				return result.validate.ok()
			end

			return result.validate.err(shared.joinArrays(validateResult0.issues, validateResult1.issues))
		end,
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
				issue.parse.failedToParse("unable to figure out what parser to use"),
			})
		end
	)
end

return unionSchema
