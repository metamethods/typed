const issue = {}

export type Issue<T = any> = {
	type: T,
	message: string,
	context: string?,
}

function issue.appendContext<T>(issue: Issue<T>, context: string): Issue<T>
	if issue.context then
		issue.context ..= `; {context}`
	else
		issue.context = context
	end

	return issue
end

function issue.formatIssue(issue: Issue): string
	return `{if issue.context then `{issue.context}: ` else ""}{issue.type} - {issue.message}`
end

function issue.formatIssues(issues: { Issue }): string
	local formattedIssues = {}

	for _, v in issues do
		table.insert(formattedIssues, issue.formatIssue(v))
	end

	return table.concat(formattedIssues, "\n")
end

issue.validate = {}

export type ValidateIssueType =
	"invalid_type"
	| "invalid_length"
	| "invalid_match"
	| "invalid_value"
	| "missing_key"
	| "extra_key"

export type ValidateIssue = Issue<ValidateIssueType>

function issue.validate.invalidType(message: string): ValidateIssue
	return {
		type = "invalid_type",
		message = message,
	}
end

function issue.validate.invalidLength(message: string): ValidateIssue
	return {
		type = "invalid_length",
		message = message,
	}
end

function issue.validate.invalidMatch(message: string): ValidateIssue
	return {
		type = "invalid_match",
		message = message,
	}
end

function issue.validate.invalidValue(message: string): ValidateIssue
	return {
		type = "invalid_value",
		message = message,
	}
end

function issue.validate.missingKey(message: string): ValidateIssue
	return {
		type = "missing_key",
		message = message,
	}
end

function issue.validate.extraKey(message: string): ValidateIssue
	return {
		type = "extra_key",
		message = message,
	}
end

issue.parse = {}

export type ParseIssueType = "validate_failed" | "missing_data"

export type ParseIssue = Issue<ParseIssueType>

function issue.parse.validateFailed(validateIssue: { ValidateIssue }): ParseIssue
	return {
		type = "validate_failed",
		message = issue.formatIssues(validateIssue),
	}
end

function issue.parse.missingData(message: string): ParseIssue
	return {
		type = "missing_data",
		message = message,
	}
end

return issue
