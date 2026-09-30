const fs = require("@lute/fs")
const process = require("@lute/process")

const PACKAGES_DIRECTORY = `./packages`

for _, packageDirectoryEntry in fs.listdir(PACKAGES_DIRECTORY) do
	if packageDirectoryEntry.type ~= "dir" then
		continue
	end

	const packageDirectoryPath = `{PACKAGES_DIRECTORY}/{packageDirectoryEntry.name}`
	const darkluaConfigurationPath = `{packageDirectoryPath}/darklua.json`

	if not fs.exists(darkluaConfigurationPath) then
		continue
	end

	print("processing", packageDirectoryPath)

	const result = process.run({
		"darklua",
		"process",
		packageDirectoryPath,
		packageDirectoryPath,
		"-c",
		darkluaConfigurationPath,
	})

	if not result.ok then
		print(`failed to run darklua command with exit code {result.exitcode}`)
		print(result.stderr)
	else
		print(result.stdout)
	end
end
