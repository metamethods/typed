const issue = require("../../issue")
const result = require("../../result")
const schema = require("../../schema")

const function formatForOutput(value: any?): string
	if value == nil then
		return "nil"
	end

	if typeof(value) == "string" then
		return `"{value}"`
	end

	return tostring(value)
end

const function literalsSchemaBuilder<T>(...: T)
	local literals = table.pack(...)
	local acceptedLiterals = table.create(literals.n)

	for index = 1, literals.n do
		local literal = literals[index]
		acceptedLiterals[index] = formatForOutput(literal)
	end

	return schema.createSchema<<T, nil>>("literals", function(value)
		for index = 1, literals.n do
			local literal = literals[index]

			if value == literal then
				return result.parse.ok(value :: T)
			end
		end

		return result.parse.err({
			issue.parse.invalidValue(
				`expected one of literal values ({table.concat(acceptedLiterals, ", ")}), got {formatForOutput(value)}`
			),
		})
	end)
end

return literalsSchemaBuilder
