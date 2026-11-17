const engine = require("@packages/engine")

type infer<T> = engine.infer<T>

type shape<T> = engine.shape<T>

type metadata<T> = engine.metadata<T>

type InnerSchema<S, M> = engine.InnerSchema<S, M>

type function get_inferred(ty: type): type
	const inferredTypes = {}

	for _, type in ty:components() do
		table.insert(inferredTypes, infer(type) :: type)
	end

	return types.intersectionof(table.unpack(inferredTypes))
end

type function get_shape(ty: type): type
	const innerSchemaTys = {}

	for index, type in ty:components() do
		table.insert(innerSchemaTys, InnerSchema(shape(type), metadata(type)) :: type)
	end

	const union = types.unionof(table.unpack(innerSchemaTys))

	return types.newtable(nil, {
		index = types.number,
		readresult = union,
		writeresult = union,
	})
end

const function intersectSchemaBuilder<T>(...: T)
	const schemas: { engine.AnySchema } = { ... }
	const innerSchemas = {}

	for _, schema in schemas do
		assert(schema.type == "table", "expected table schema")

		table.insert(innerSchemas, engine.schema.innerSchema(schema))
	end

	return engine.schema.createSchema<<get_inferred<T>, get_shape<T>, nil>>("intersect", function(value)
		const parsedValues = {}
		const issues = {}

		for _, schema in schemas do
			const result = schema.parse(value)

			if not result.ok then
				for _, issue in result.issues do
					table.insert(issues, issue)
				end

				continue
			end

			table.insert(parsedValues, result.value)
		end

		if #issues > 0 then
			return engine.parseResult.err(issues)
		end

		const merged = {}

		for key, value in parsedValues :: any do
			if merged[key] then
				return engine.parseResult.err({
					engine.parseIssue.appendContext(
						engine.parseIssue.create("key_conflict", `key conflict with {key}`),
						`{key}`
					),
				})
			end

			merged[key] = value
		end

		return engine.parseResult.ok(merged :: get_inferred<T>)
	end, innerSchemas :: get_shape<T>)
end

return intersectSchemaBuilder
