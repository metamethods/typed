const engine = require("@packages/engine")

const function format(value: any): string
	if value == nil then
		return "nil"
	end

	if typeof(value) == "string" then
		return `"{value}"`
	end

	return tostring(value)
end

const function enumSchemaBuilder<T>(...: (T & string) | "")
	const enumItems = { ... }
	const formattedAcceptedEnumItems = table.create(#enumItems)

	for index, enumItem in enumItems do
		formattedAcceptedEnumItems[index] = format(enumItem)
	end

	const formattedAcceptedEnumItemsString = table.concat(formattedAcceptedEnumItems, ", ")

	return engine.schema.createSchema<<T, nil, nil>>("enum", function(value)
		for _, enumItem in enumItems do
			if enumItem == value then
				return engine.parseResult.ok(value)
			end
		end

		return engine.parseResult.err({
			engine.parseIssue.create(
				"invalid_value",
				`expected one of literal values ({formattedAcceptedEnumItemsString}), got {format(value)}`
			),
		})
	end)
end

return enumSchemaBuilder
