const issue = require("./issue")

const result = {}

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
