const issue = require("./issue")

const result = {}

result.validate = {}

export type ValidateResultOk = { ok: true }

export type ValidateResultErr = { ok: false, issues: { issue.ValidateIssue } }

export type ValidateResult = ValidateResultOk | ValidateResultErr

function result.validate.ok(): ValidateResultOk
	return { ok = true }
end

function result.validate.err(issues: { issue.ValidateIssue }): ValidateResultErr
	return { ok = false, issues = issues }
end

result.parse = {}

export type ParseResultOk<T> = { ok: true, value: T }

export type ParseResultErr = {
	ok: false,
	issues: { issue.ParseIssue },
}

export type ParseResult<T> = ParseResultOk<T> | ParseResultErr

function result.parse.ok<T>(value: T): ParseResultOk<T>
	return { ok = true, value = value }
end

function result.parse.err(issues: { issue.ParseIssue }): ParseResultErr
	return { ok = false, issues = issues }
end

return result
