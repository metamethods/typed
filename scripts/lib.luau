const fs = require("@lune/fs")
const process = require("@lune/process")

const function pathExists(path: string): boolean
	const metadata = fs.metadata(path)
	return metadata.exists
end

type RunOptions = process.ExecOptions & {
	mustRun: boolean?,
}

const function run(program: string, params: { string }?, options: RunOptions?): process.ExecResult
	const options: RunOptions = options or {}
	const result = process.exec(program, params, options)
	if not result.ok and options.mustRun then
		error(`{program} {table.concat(params or {}, " ")} failed ({result.code})\n{result.stdout}\n{result.stderr}`)
	end
	return result
end

return {
	pathExists = pathExists,
	run = run,
}
