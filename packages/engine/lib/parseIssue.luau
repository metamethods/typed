const parseIssue = {}

export type ParseIssueType =
	| "refine_error"
	| "invalid_value"
	| "invalid_type"
	| "invalid_union"
	| "missing_data"
	| "extra_key"
	| "unmergeable_value"
	| "key_conflict"

export type ParseIssue = {
	type: string,
	message: string,
	context: string?,
}

function parseIssue.appendContext(issue: ParseIssue, context: string): ParseIssue
	if issue.context then
		issue.context = `{context}; {issue.context}`
	else
		issue.context = context
	end

	return issue
end

function parseIssue.formatIssue(issue: ParseIssue): string
	return `{if issue.context then `{issue.context}: ` else ""}{issue.type} - {issue.message}`
end

function parseIssue.formatIssues(issues: { ParseIssue }): string
	const formattedIssues = {}

	for _, v in issues do
		table.insert(formattedIssues, parseIssue.formatIssue(v))
	end

	return table.concat(formattedIssues, "\n")
end

function parseIssue.create(issueType: ParseIssueType, message: string): ParseIssue
	return {
		type = issueType,
		message = message,
	}
end

function parseIssue.createOther(issueType: string, message: string): ParseIssue
	return {
		type = issueType,
		message = message,
	}
end

return parseIssue
