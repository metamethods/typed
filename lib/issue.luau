const issue = {}

export type Issue<T = any> = {
	type: T,
	message: string,
	context: string?,
}

function issue.appendContext<T>(issue: Issue<T>, context: string): Issue<T>
	if issue.context then
		issue.context = `{context}; {issue.context}`
	else
		issue.context = context
	end

	return issue
end

function issue.formatIssue(issue: Issue): string
	return `{if issue.context then `{issue.context}: ` else ""}{issue.type} - {issue.message}`
end

function issue.formatIssues(issues: { Issue }): string
	const formattedIssues = {}

	for _, v in issues do
		table.insert(formattedIssues, issue.formatIssue(v))
	end

	return table.concat(formattedIssues, "\n")
end

issue.parse = {}

export type ParseIssueType =
	| "refine_error"
	| "invalid_value"
	| "invalid_type"
	| "invalid_union"
	| "missing_data"
	| "extra_key"
	| "unmergeable_value"
	| "key_conflict"

export type ParseIssue = Issue<ParseIssueType>

function issue.parse.refineError(message: string): ParseIssue
	return {
		type = "refine_error",
		message = message,
	}
end

function issue.parse.invalidValue(message: string): ParseIssue
	return {
		type = "invalid_value",
		message = message,
	}
end

function issue.parse.invalidType(message: string): ParseIssue
	return {
		type = "invalid_type",
		message = message,
	}
end

function issue.parse.invalidUnion(message: string): ParseIssue
	return {
		type = "invalid_union",
		message = message,
	}
end

function issue.parse.missingData(message: string): ParseIssue
	return {
		type = "missing_data",
		message = message,
	}
end

function issue.parse.extraKey(message: string): ParseIssue
	return {
		type = "extra_key",
		message = message,
	}
end

function issue.parse.unmergeableValue(message: string): ParseIssue
	return {
		type = "unmergeable_value",
		message = message,
	}
end

function issue.parse.keyConflict(message: string): ParseIssue
	return {
		type = "key_conflict",
		message = message,
	}
end

return issue
