const engine = require("@packages/engine")

type Schema<T, S, M> = engine.Schema<T, S, M>

type InnerSchema<S, M> = engine.InnerSchema<S, M>

type infer<T> = engine.infer<T>

type metadata<T> = engine.metadata<T>

type shape<T> = engine.shape<T>

type function infer_from_fields(fieldsTy: type)
	assert(fieldsTy:is("table"), "requires a table type")

	const resultTy = types.newtable()

	for key, value in fieldsTy:properties() do
		if value.read then
			resultTy:setproperty(key, infer(value.read))
		end
	end

	return resultTy
end

type function shape_from_fields(fieldsTy: type)
	assert(fieldsTy:is("table"), "requires a table type")

	const tableResultTy = types.newtable()

	local shapeResultTy: type?
	local metadataResultTy: type?

	for keyTy, valueTy in fieldsTy:properties() do
		if not valueTy.read then
			continue
		end

		const readValueTy = valueTy.read

		tableResultTy:setproperty(keyTy, InnerSchema(shape(readValueTy), metadata(readValueTy)))

		const shapeTy: type = shape(readValueTy)
		if not shapeResultTy then
			shapeResultTy = shapeTy
		elseif not shapeTy:issubtypeof(shapeResultTy) then
			shapeResultTy = types.unionof(shapeTy, shapeResultTy)
		end

		const metadataTy: type = metadata(readValueTy)
		if not metadataResultTy then
			metadataResultTy = metadataTy
		elseif not metadataTy:issubtypeof(metadataResultTy) then
			metadataResultTy = types.unionof(metadataTy, metadataResultTy)
		end
	end

	const indexerTy = types.newtable()
	indexerTy:setindexer(types.string, InnerSchema(shapeResultTy or types.unknown, metadataResultTy or types.unknown))

	return types.intersectionof(tableResultTy, indexerTy)
end

type TableOptions = {
	strict: boolean?,
	shortCircuitStrict: boolean?,
}

const function tableSchemaBuilder<T>(fields: T, options: TableOptions?)
	const options: TableOptions = options or {}

	const fields = fields :: { [string]: engine.UnknownSchema }

	for key, _ in fields do
		assert(type(key) == "string", `expected string type key, got {key} ({typeof(key)})`)
	end

	const shape = {}

	for key, valueSchema in fields do
		shape[key] = engine.schema.innerSchema(valueSchema)
	end

	return engine.schema.createSchema<<infer_from_fields<T>, shape_from_fields<T>, nil>>("table", function(value)
		if type(value) ~= "table" then
			return engine.parseResult.err({
				engine.parseIssue.create("invalid_type", `expected table, got {typeof(value)}`),
			})
		end

		const issues = {}
		const parsedTable: { [string]: unknown } = {}

		for key, schema in fields do
			const schemaParseResult = schema.parse(value[key])

			if not schemaParseResult.ok then
				for _, issue in schemaParseResult.issues do
					table.insert(issues, engine.parseIssue.appendContext(issue, `index: {key}`))
				end

				continue
			end

			if parsedTable[key] then
				table.insert(issues, engine.parseIssue.create("key_conflict", `found key duplicate: {key}`))

				continue
			end

			parsedTable[key] = schemaParseResult.value
		end

		if options.strict then
			for key, _ in value do
				if not fields[key] then
					table.insert(
						issues,
						engine.parseIssue.appendContext(
							engine.parseIssue.create("extra_key", `extra key provided`),
							`index: {key}`
						)
					)

					if options.shortCircuitStrict then
						break
					end
				end
			end
		end

		if #issues > 0 then
			return engine.parseResult.err(issues)
		end

		return engine.parseResult.ok(parsedTable :: infer_from_fields<T>)
	end, shape :: shape_from_fields<T>)
end

return tableSchemaBuilder
