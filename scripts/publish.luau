const fs = require("@lute/fs")
const lib = require("./lib")

for _, packageDirectoryEntry in fs.listdir(lib.PACKAGES_DIRECTORY_PATH) do
	const ok, errorString = lib.stage(
		`{lib.PACKAGES_DIRECTORY_PATH}/{packageDirectoryEntry.name}`,
		function(stagingDirectoryPath)
			const libPath = `{stagingDirectoryPath}/lib`
			const darkluaConfigPath = `{stagingDirectoryPath}/darklua.json`

			if fs.exists(darkluaConfigPath) then
				lib.darkluaProcess(libPath, darkluaConfigPath)
			end

			lib.mustRun(`cd {stagingDirectoryPath} && pesde publish --yes && cd -`)
		end
	)

	assert(ok, errorString)
end
