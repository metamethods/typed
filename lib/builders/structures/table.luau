const result = require("../../result")
const issue = require("../../issue")
const schema = require("../../schema")
const shared = require("../../shared")

type Schema<T, S, M> = schema.Schema<T, S, M>

type infer<T> = shared.infer<T>

type function infer_shape(tableShapeTy: type)
	assert(tableShapeTy:is("table"), "requires a table type")

	const resultTy = types.newtable()

	for key, value in tableShapeTy:properties() do
		if value.read then
			resultTy:setproperty(key, infer(value.read))
		end
	end

	return resultTy
end

type TableOptions = {
	strict: boolean?,
	shortCircuitStrict: boolean?,
}

const function tableSchemaBuilder<T>(tableShape: T, options: TableOptions?)
	const options: TableOptions = options or {}

	const tableShape = tableShape :: { [string]: schema.UnknownSchema }

	for key, _ in tableShape do
		assert(type(key) == "string", `expected string type key, got {key} ({typeof(key)})`)
	end

	return schema<<{} & infer_shape<T>, T>>("table", function(value)
		if type(value) ~= "table" then
			return result.parse.err({
				issue.parse.invalidType(`expected table, got {typeof(value)}`),
			})
		end

		const issues = {}
		const parsedTable: { [string]: unknown } = {}

		for key, schema in tableShape do
			const schemaParseResult = schema.parse(value[key])

			if not schemaParseResult.ok then
				for _, parseIssue in schemaParseResult.issues do
					table.insert(issues, issue.appendContext(parseIssue, `index: {key}`))
				end

				continue
			end

			if parsedTable[key] then
				table.insert(issues, issue.parse.keyConflict(`found key duplicate: {key}`))

				continue
			end

			parsedTable[key] = schemaParseResult.value
		end

		if options.strict then
			for key, _ in value do
				if not tableShape[key] then
					table.insert(
						issues,
						issue.appendContext(issue.parse.extraKey(`extra key provided`), `index: {key}`)
					)

					if options.shortCircuitStrict then
						break
					end
				end
			end
		end

		if #issues > 0 then
			return result.parse.err(issues)
		end

		return result.parse.ok(parsedTable :: infer_shape<T>)
	end, tableShape :: any)
end

return tableSchemaBuilder
