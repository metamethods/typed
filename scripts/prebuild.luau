const fs = require("@lute/fs")
const process = require("@lute/process")

const PACKAGES_DIRECTORY = `./packages`

const packageForPrebuild = process.args[2]

for _, packageDirectoryEntry in fs.listdir(PACKAGES_DIRECTORY) do
	if packageDirectoryEntry.type ~= "dir" then
		continue
	end

	if packageDirectoryEntry.name ~= packageForPrebuild then
		continue
	end

	const packageDirectoryPath = `{PACKAGES_DIRECTORY}/{packageDirectoryEntry.name}`
	const rojoProjectConfigPath = `{packageDirectoryPath}/default.project.json`
	const luaurcConfigPath = `{packageDirectoryPath}/.luaurc`
	const luauPackagesDirectoryPath = `{packageDirectoryPath}/luau_packages`
	const packageLibDirectoryPath = `{packageDirectoryPath}/lib`

	if
		not fs.exists(rojoProjectConfigPath)
		or not fs.exists(luauPackagesDirectoryPath)
		or not fs.exists(packageLibDirectoryPath)
	then
		continue
	end

	const result = process.system(
		`mv {luauPackagesDirectoryPath} {packageLibDirectoryPath} && sed -i 's#"packages": "./luau_packages"#"packages": "./lib/luau_packages"#' {luaurcConfigPath}`
	)

	if not result.ok then
		print(`failed to run command with exit code {result.exitcode}`)
		print(result.stderr)
		process.exit(1)
	else
		print(result.stdout)
		process.exit(0)
	end
end

process.exit(1)
print("no package was found for", packageForPrebuild)
