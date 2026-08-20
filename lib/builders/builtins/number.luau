const like = require("../base/like")
const refine = require("../base/refine")

type NumberOptions = {
	unbounded: boolean?,
	min: number?,
	max: number?,
}

const function numberSchemaBuilder(options: NumberOptions?)
	const options: NumberOptions = options or {}

	return refine(like<<number>>("number"))(function(value, result)
		if not options.unbounded and (math.isnan(value) or math.isinf(value)) then
			return result.err(`expected a finite number, got {tostring(value)}`)
		end

		if options.min and value < options.min then
			return result.err(`expected number at least {options.min}, got {value}`)
		end

		if options.max and value > options.max then
			return result.err(`expected number at most {options.max}, got {value}`)
		end

		return result.ok()
	end)
end

return numberSchemaBuilder
