const result = require("../../result")
const issue = require("../../issue")
const schema = require("../../schema")

-- stylua: ignore
type function infer(schema: type)
    assert(schema:is("table"), "requires a table type")
	for key, value in schema:properties() do if key:is("singleton") and key:value() == "_infer" and value.read then return value.read end end
	error("shape has no readble 'infer' property")
end

type function infer_shape(shape: type)
	assert(shape:is("table"), "requires a table type")

	const result = types.newtable()

	for key, value in shape:properties() do
		if value.read then
			result:setreadproperty(key, infer(value.read))
		end

		if value.write then
			result:setwriteproperty(key, infer(value.write))
		end
	end

	return result
end

type TableOptions = {
	strict: boolean?,
}

const function tableSchema<T>(shape: T, options: TableOptions?): schema.Schema<infer_shape<T>>
	const options: TableOptions = options or {}

	const shape = shape :: { [any]: schema.Schema<unknown> }

	return schema<<infer_shape<T>>>(function(value)
		if type(value) ~= "table" then
			return result.validate.err({
				issue.validate.invalidType(`expected table, got {typeof(value)}`),
			})
		end

		const issues = {}

		for key, schema in shape do
			if not value[key] then
				table.insert(issues, issue.appendContext(issue.validate.missingKey(`missing key`), `{key}`))
				continue
			end

			const validationResult = schema.validate(value[key])

			if not validationResult.ok then
				for _, validationIsue in validationResult.issues do
					table.insert(issues, issue.appendContext(validationIsue, `{key}`))
				end
			end
		end

		if options.strict then
			for key, _ in value do
				if not shape[key] then
					table.insert(issues, issue.appendContext(issue.validate.extraKey(`extra key provided`), `{key}`))
				end
			end
		end

		if #issues > 0 then
			return result.validate.err(issues)
		end

		return result.validate.ok()
	end)
end

return tableSchema
