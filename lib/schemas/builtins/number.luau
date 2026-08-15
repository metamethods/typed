const result = require("../../result")
const issue = require("../../issue")
const primitive = require("../base/primitive")

type NumberOptions = {
	unbounded: boolean?,
	min: number?,
	max: number?,
}

const function numberSchema(options: NumberOptions?)
	const options: NumberOptions = options or {}

	return primitive<<number>>("number", function(value)
		if not options.unbounded and (math.isnan(value) or math.isinf(value)) then
			return result.validate.err({
				issue.validate.invalidValue(`expected a finite number, got {tostring(value)}`),
			})
		end

		if options.min and value < options.min then
			return result.validate.err({
				issue.validate.invalidValue(`expected number at least {options.min}, got {value}`),
			})
		end

		if options.max and value > options.max then
			return result.validate.err({
				issue.validate.invalidValue(`expected number at most {options.max}, got {value}`),
			})
		end

		return result.validate.ok()
	end)
end

return numberSchema
