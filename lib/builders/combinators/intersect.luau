const issue = require("../../issue")
const shared = require("../../shared")
const result = require("../../result")
const schema = require("../../schema")

type infer<T> = shared.infer<T>

type function infer_intersection(ty: type): type
	local resultingType: type?

	for _, ty: type in ty:parameters().head :: { type } do
		if not resultingType then
			resultingType = infer(ty)
		else
			resultingType = types.intersectionof(resultingType, infer(ty))
		end
	end

	return if not resultingType then types.unknown else resultingType
end

const function intersectSchemaBuilder<T...>(...: T...)
	const schemas = table.pack(... :: unknown) :: { schema.Schema<unknown> }

	return schema<<infer_intersection<(T...) -> ()>>>(function(value)
		local issues: { issue.ValidateIssue } = {}

		for _, schema in schemas do
			const validationResult = schema.validate(schema)

			if not validationResult.ok then
				issues = shared.joinArrays(issues, validationResult.issues)
			end
		end

		if #issues == 0 then
			return result.validate.ok()
		end

		return result.validate.err(issues)
	end, function(value)
		const mergingTables: { { [unknown]: unknown } } = {}

		for _, schema in schemas do
			const parseResult = schema.parse(value)

			if not parseResult.ok then
				return parseResult
			end

			if type(parseResult.value) ~= "table" then
				return result.parse.err({
					issue.parse.unmergeableValue(
						`unable to merge value; expected table, got {typeof(parseResult.value)}`
					),
				})
			end

			table.insert(mergingTables, parseResult.value :: { [unknown]: unknown })
		end

		const merged: { [unknown]: unknown } = {}

		for _, mergingTable in mergingTables do
			for key, value in mergingTable do
				if merged[key] then
					return result.parse.err({
						issue.appendContext(issue.parse.keyConflict(`key conflict with {key}`), `{key}`),
					})
				end

				merged[key] = value
			end
		end

		return result.parse.ok(merged :: infer_intersection<(T...) -> ()>)
	end)
end

return intersectSchemaBuilder
