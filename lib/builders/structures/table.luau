const result = require("../../result")
const issue = require("../../issue")
const schema = require("../../schema")
const shared = require("../../shared")

type Schema<T, S, M> = schema.Schema<T, S, M>

type infer<T> = shared.infer<T>

type metadata<T> = shared.metadata<T>

type shape<T> = shared.shape<T>

export type function expect_string(ty: type)
	assert(not ty:is("intersection"), "intersection type is not allowed")

	if ty:is("union") then
		for _, componentTy in ty:components() do
			expect_string(componentTy)
		end
	else
		assert(ty:issubtypeof(types.string), `expected string, got {ty.tag}`)
	end

	return ty
end

type function infer_shape(tableShapeTy: type)
	assert(tableShapeTy:is("table"), "requires a table type")

	const indexer = tableShapeTy:indexer()

	if indexer then
		expect_string(indexer.index)
	end

	const resultTy = types.newtable()

	for key, value in tableShapeTy:properties() do
		expect_string(key)

		if value.read then
			resultTy:setproperty(key, infer(value.read))
		end
	end

	return resultTy
end

type function infer_common_schema(tableShapeTy: type)
	assert(tableShapeTy:is("table"), "requires a table type")

	local inferResultTy: type?
	local shapeResultTy: type?
	local metadataResultTy: type?

	for _, valueTy in tableShapeTy:properties() do
		if not valueTy.read then
			continue
		end

		const readValueTy = valueTy.read

		inferResultTy = if inferResultTy then types.unionof(infer(readValueTy), inferResultTy) else infer(readValueTy)
		shapeResultTy = if shapeResultTy then types.unionof(shape(readValueTy), shapeResultTy) else shape(readValueTy)
		metadataResultTy = if metadataResultTy
			then types.unionof(metadata(readValueTy), metadataResultTy)
			else metadata(readValueTy)
	end

	return Schema(
		if inferResultTy == nil then types.unknown else inferResultTy,
		if shapeResultTy == nil then types.unknown else shapeResultTy,
		if metadataResultTy == nil then types.unknown else metadataResultTy
	)
end

type TableOptions = {
	strict: boolean?,
}

const function tableSchemaBuilder<T>(tableShape: T, options: TableOptions?)
	const options: TableOptions = options or {}

	const tableShape = tableShape :: { [string]: schema.UnknownSchema }

	for key, _ in tableShape do
		assert(type(key) == "string", `expected string type key, got {key} ({typeof(key)})`)
	end

	return schema<<infer_shape<T>, T & { [string]: infer_common_schema<T>? }, nil>>("table", function(value)
		if type(value) ~= "table" then
			return result.validate.err({
				issue.validate.invalidType(`expected table, got {typeof(value)}`),
			})
		end

		const issues = {}

		for key, schema in tableShape do
			const validationResult = schema.validate(value[key])

			if not validationResult.ok then
				for _, validationIsue in validationResult.issues do
					table.insert(issues, issue.appendContext(validationIsue, `{key}`))
				end
			end
		end

		if options.strict then
			for key, _ in value do
				if not tableShape[key] then
					table.insert(issues, issue.appendContext(issue.validate.extraKey(`extra key provided`), `{key}`))
				end
			end
		end

		if #issues > 0 then
			return result.validate.err(issues)
		end

		return result.validate.ok()
	end, function(value)
		const newTable = {}
		const issues = {}

		for key, schema in tableShape do
			const parseResult = schema.parse(value[key])

			if parseResult.ok then
				newTable[key] = parseResult.value
			else
				for _, parseIssue in parseResult.issues do
					table.insert(issues, issue.appendContext(parseIssue, `{key}`))
					continue
				end
			end
		end

		if #issues > 0 then
			return result.parse.err(issues)
		end

		return result.parse.ok(newTable :: infer_shape<T>)
	end, tableShape :: infer_common_schema<T>)
end

return tableSchemaBuilder
