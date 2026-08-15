const result = require("../../result")
const issue = require("../../issue")
const primitive = require("../base/primitive")

type StringOptions = {
	match: string?,
	length: {
		min: number?,
		max: number?,
	}?,
}

const function stringSchema(options: StringOptions?)
	const options: StringOptions = options or {}

	return primitive<<string>>("string", function(value)
		if options.match and not string.match(value, options.match) then
			return result.validate.err({
				issue.validate.invalidMatch(`expected string matching pattern {options.match}, got {tostring(value)}`),
			})
		end

		if options.length then
			if options.length.min and #value < options.length.min then
				return result.validate.err({
					issue.validate.invalidLength(
						`expected string with length at least {options.length.min}, got {#value}`
					),
				})
			end

			if options.length.max and #value > options.length.max then
				return result.validate.err({
					issue.validate.invalidLength(
						`expected string with length at most {options.length.max}, got {#value}`
					),
				})
			end
		end

		return result.validate.ok()
	end)
end

return stringSchema
