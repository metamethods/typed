const issue = require("../issue")
const shared = require("../shared")
const result = require("../result")
const schema = require("../schema")

const function intersectSchema<T0, T1>(
	schemaA: T0,
	schemaB: T1
): schema.Schema<
	shared.infer<T0> & shared.infer<T1>,
	shared.infer_parse<T0> & shared.infer_parse<T1>
>
	const schemaA = schemaA :: schema.Schema<shared.infer<T0>, shared.infer_parse<T0>>
	const schemaB = schemaB :: schema.Schema<shared.infer<T1>, shared.infer_parse<T1>>

	return schema<<shared.infer<T0> & shared.infer<T1>, shared.infer_parse<T0> & shared.infer_parse<T1>>>(
		function(value)
			const validateResult0 = schemaA.validate(value)
			const validateResult1 = schemaB.validate(value)

			if validateResult0.ok and validateResult1.ok then
				return result.validate.ok()
			end

			-- they should both be an error variant at this point
			-- guess the new luau solver is not detecting that?? lol
			const validateResult0 = validateResult0 :: result.ValidateResultErr
			const validateResult1 = validateResult1 :: result.ValidateResultErr

			return result.validate.err(shared.joinArrays(validateResult0.issues, validateResult1.issues))
		end,
		function(value)
			--!todo: this probably needs a rewrite, but it should suffice for now i guess...

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
		end
	)
end

return intersectSchema
