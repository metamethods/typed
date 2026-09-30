const fs = require("@lute/fs")
const process = require("@lute/process")

const PACKAGES_DIRECTORY = `./packages`

const packageToBuild = process.args[1]

for _, packageDirectoryEntry in fs.listdir(PACKAGES_DIRECTORY) do
	if packageDirectoryEntry.type ~= "dir" then
		continue
	end

	if packageDirectoryEntry.name ~= packageToBuild then
		continue
	end

	const packageDirectoryPath = `{PACKAGES_DIRECTORY}/{packageDirectoryEntry.name}`
	const rojoProjectConfigPath = `{packageDirectoryPath}/default.project.json`

	if not fs.exists(rojoProjectConfigPath) then
		continue
	end

	print("building", packageDirectoryPath)

	const result = process.run({
		"rojo",
		"build",
		packageDirectoryPath,
		"--output",
		`{packageDirectoryEntry.name}.rbxm`,
	})

	if not result.ok then
		print(`failed to run rojo build command with exit code {result.exitcode}`)
		print(result.stderr)
		process.exit(1)
	else
		print(result.stdout)
	end

	break
end
