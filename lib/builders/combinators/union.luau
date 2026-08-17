const issue = require("../../issue")
const shared = require("../../shared")
const result = require("../../result")
const schema = require("../../schema")

type infer<T> = shared.infer<T>

type function infer_union(ty: type): type
	local resultingType: type?

	for _, ty: type in ty:parameters().head :: { type } do
		if not resultingType then
			resultingType = infer(ty)
		else
			resultingType = types.unionof(resultingType, infer(ty))
		end
	end

	return if not resultingType then types.unknown else resultingType
end

const function unionSchema<T...>(...: T...)
	const schemas = table.pack(... :: unknown) :: { schema.Schema<unknown> }

	return schema<<infer_union<(T...) -> ()>>>(function(value)
		local issues: { issue.ValidateIssue } = {}

		for _, schema in schemas do
			const validationResult = schema.validate(schema)

			if validationResult.ok then
				return result.validate.ok()
			else
				issues = shared.joinArrays(issues, validationResult.issues)
			end
		end

		return result.validate.err(issues)
	end, function(value)
		for _, schema in schemas do
			const parseResult = schema.parse(schema)

			if parseResult.ok then
				-- return result.parse.ok(parseResult.value :: infer_union<(T...) -> ()>)
			end
		end

		return result.parse.err({
			issue.parse.failedToParse("unable to figure out what parser to use"),
		})
	end)
end

return unionSchema
