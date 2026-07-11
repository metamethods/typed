const shared = require("../shared")
const result = require("../result")
const schema = require("../schema")

const function intersectSchema<T0, T1>(schemaA: T0, schemaB: T1): schema.Schema<shared.infer<T0> & shared.infer<T1>>
	const schemaA = schemaA :: schema.Schema<T0>
	const schemaB = schemaB :: schema.Schema<T1>

	return schema<<shared.infer<T0> & shared.infer<T1>>>(function(value)
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
	end)
end

return intersectSchema
