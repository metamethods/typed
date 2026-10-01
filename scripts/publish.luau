const process = require("@lute/process")
const fs = require("@lute/fs")
const lib = require("./lib")

const packageToBuild = process.args[2]

const packageDirectoryPath = lib.getCheckedPackageDirectoryPathFromName(packageToBuild)

assert(packageDirectoryPath, `expected for an existing package directory`)

const ok, errorString = lib.stage(packageDirectoryPath, function(stagingDirectoryPath)
	const libPath = `{stagingDirectoryPath}/lib`
	const darkluaConfigPath = `{stagingDirectoryPath}/darklua.json`

	if fs.exists(darkluaConfigPath) then
		lib.darkluaProcess(libPath, darkluaConfigPath)
	end

	lib.mustRun(`cd {stagingDirectoryPath} && pesde publish --yes`)
end)

assert(ok, errorString)
