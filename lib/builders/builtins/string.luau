const like = require("../base/like")
const refine = require("../base/refine")

type StringOptions = {
	match: string?,
	length: {
		min: number?,
		max: number?,
	}?,
}

const function stringSchemaBuilder(options: StringOptions?)
	const options: StringOptions = options or {}

	return refine(like<<string>>("string"))(function(value, result)
		if options.match and not string.match(value, options.match) then
			return result.err(`expected string matching pattern {options.match}, got {tostring(value)}`)
		end

		if options.length then
			if options.length.min and #value < options.length.min then
				return result.err(`expected string with length at least {options.length.min}, got {#value}`)
			end

			if options.length.max and #value > options.length.max then
				return result.err(`expected string with length at most {options.length.max}, got {#value}`)
			end
		end

		return result.ok()
	end)
end

return stringSchemaBuilder
