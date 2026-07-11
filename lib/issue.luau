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

export type ParseIssueType = nil

export type ParseIssue = Issue<ParseIssueType>

return issue
