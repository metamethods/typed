const core = require("@packages/typed_core")

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

	return core.schema.createSchema<<T, nil, nil>>("literals", function(value)
		for index = 1, literals.n do
			local literal = literals[index]

			if value == literal then
				return core.parseResult.ok(value :: T)
			end
		end

		return core.parseResult.err({
			core.parseIssue.create(
				"invalid_value",
				`expected one of literal values ({table.concat(acceptedLiterals, ", ")}), got {formatForOutput(value)}`
			),
		})
	end)
end

return literalsSchemaBuilder
