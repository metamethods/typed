const issue = require("./issue")

export type function infer(schema: type)
	assert(schema:is("table"), "requires a table type")

	for key, value in schema:properties() do
		if key:is("singleton") and key:value() == "_infer" and value.read then
			return value.read
		end
	end

	error("shape has no readble 'infer' property")
end

const function formatIssue(issue: issue.Issue): string
	return `{if issue.context then `{issue.context}: ` else ""}{issue.type} - {issue.message}`
end

const function formatIssues(issues: { issue.Issue }): string
	local formattedIssues = {}

	for _, issue in issues do
		table.insert(formattedIssues, formatIssue(issue))
	end

	return table.concat(formattedIssues, "\n")
end

const function joinArrays<T>(...: { T }): { T }
	const result = {}

	for _, array in { ... } do
		for _, value in array do
			table.insert(result, value)
		end
	end

	return result
end

return {
	formatIssue = formatIssue,
	formatIssues = formatIssues,
	joinArrays = joinArrays,
}
