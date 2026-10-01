const fs = require("@lute/fs")
const process = require("@lute/process")

const PACKAGES_DIRECTORY_PATH = "./packages"
const STAGING_DIRECTORY_NAME = ".staging"

const function mustRun(command: { string } | string, noPrintStdout: boolean?): process.ProcessResult
	const result = if type(command) == "string" then process.system(command) else process.run(command)
	assert(result.ok, result.stderr)
	if not result.stdout:match("^%s*$") and not noPrintStdout then
		print(result.stdout:match("^%s*(.-)%s*$"))
	end
	return result
end

const function generateUuid(): string?
	return (mustRun("uuidgen", true).stdout:match("^%s*(.-)%s*$") or ""):lower()
end

const function getCheckedPackageDirectoryPathFromName(name: string): string?
	const path = `{PACKAGES_DIRECTORY_PATH}/{name}`

	if not fs.exists(path) then
		return nil
	end

	if fs.stat(path).type ~= "dir" then
		return nil
	end

	return path
end

-- creates a temporary copy for any transformations / staging for publishing
const function stage(directoryPath: string, callback: (stagingFilePath: string) -> ()): (boolean, string)
	assert(fs.exists(directoryPath), `expected {directoryPath} to exist`)
	assert(fs.stat(directoryPath).type == "dir", `expected a directory`)

	const stagingDirectoryPath = `{STAGING_DIRECTORY_NAME}/{generateUuid()}`

	if not fs.exists(STAGING_DIRECTORY_NAME) then
		fs.mkdir(STAGING_DIRECTORY_NAME)
	end

	mustRun({ "cp", "-r", directoryPath, stagingDirectoryPath })

	const ok, errorString = pcall(callback, stagingDirectoryPath)

	mustRun({ "rm", "-rf", stagingDirectoryPath })

	return ok, errorString :: string
end

const function darkluaProcess(targetPath: string, darkluaConfigFilePath: string)
	mustRun({
		"darklua",
		"process",
		targetPath,
		targetPath,
		"-c",
		darkluaConfigFilePath,
	})
end

return {
	mustRun = mustRun,
	getCheckedPackageDirectoryPathFromName = getCheckedPackageDirectoryPathFromName,
	stage = stage,
	darkluaProcess = darkluaProcess,
}
