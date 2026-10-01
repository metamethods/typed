const fs = require("@lute/fs")
const process = require("@lute/process")
const lib = require("./lib")

const packageToBuild = process.args[2]

const packageDirectoryPath = lib.getCheckedPackageDirectoryPathFromName(packageToBuild)

assert(packageDirectoryPath, `expected for an existing package directory`)

const rojoProjectConfigPath = `{packageDirectoryPath}/default.project.json`

assert(fs.exists(rojoProjectConfigPath), "expected package directory to have a default.project.json")

const ok, errorString = lib.stage(packageDirectoryPath, function(stagingDirectoryPath)
	const luauPackagesPath = `{stagingDirectoryPath}/luau_packages`
	const libPath = `{stagingDirectoryPath}/lib`
	const darkluaConfigPath = `{stagingDirectoryPath}/darklua.json`
	const luaurcConfigPath = `{stagingDirectoryPath}/.luaurc`

	if fs.exists(luauPackagesPath) then
		lib.mustRun({
			"mv",
			luauPackagesPath,
			libPath,
		})

		lib.mustRun(
			`sed -i "" 's#"packages": "./luau_packages"#"packages": "./lib/luau_packages"#' "{luaurcConfigPath}"`
		)
	end

	lib.darkluaProcess(libPath, darkluaConfigPath)

	lib.mustRun({
		"rojo",
		"build",
		stagingDirectoryPath,
		"--output",
		`{packageToBuild}.rbxm`,
	})
end)

assert(ok, errorString)
