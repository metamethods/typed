const parseIssue = require("./parseIssue")

const parseResult = {}

export type ParseResultOk<T> = { ok: true, value: T }

export type ParseResultErr = {
	ok: false,
	issues: { parseIssue.ParseIssue },
}

export type ParseResult<T> = ParseResultOk<T> | ParseResultErr

function parseResult.ok<T>(value: T): ParseResultOk<T>
	return { ok = true, value = value }
end

function parseResult.err(issues: { parseIssue.ParseIssue }): ParseResultErr
	return { ok = false, issues = issues }
end

return parseResult
