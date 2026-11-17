const fs = require("@lune/fs")
const serde = require("@lune/serde")
const steps = require("./steps")
const lib = require("./lib")

type PackageConfig = {
	package: {
		name: string,
	},

	target: {
		main: string,
	},
}

export type Package = {
	name: string,
	path: string,
	config: PackageConfig,
}

const function getPackage(dir: string, entry: string): Package
	const packagePath = `{dir}/{entry}`

	const packageConfigPath = `{packagePath}/ember.toml`
	const packageConfig: PackageConfig = serde.decode("toml", fs.readFile(packageConfigPath))

	const packageName = packageConfig.package.name:split("/")[2]

	assert(packageName)

	return {
		name = packageName,
		path = packagePath,
		config = packageConfig,
	}
end

const function getPackages(dir: string): { Package }
	const packages = {}

	for _, entry in fs.readDir(dir) do
		table.insert(packages, getPackage(dir, entry))
	end

	return packages
end

export type StagedPackage = Package

const function stagePackages(stagingDir: string, packages: { Package }): { StagedPackage }
	const stagingPackages = {}

	if lib.pathExists(stagingDir) then
		fs.removeDir(stagingDir)
		fs.writeDir(stagingDir)
	end

	for _, package in packages do
		const stagedPackagePath = `{stagingDir}/{package.name}`

		fs.copy(package.path, stagedPackagePath, true)

		table.insert(stagingPackages, {
			name = package.name,
			path = stagedPackagePath,
			config = package.config,
		})
	end

	return stagingPackages
end

const darkluaTransformStep: steps.Step<StagedPackage> = function(package: StagedPackage)
	const darkluaConfigPath = `{package.path}/darklua.json`

	if not lib.pathExists(darkluaConfigPath) then
		warn(package.name, "does not have a darklua.json file; skipping")
		return
	end

	const targetPath = `{package.path}/lib`

	lib.run("darklua", { "process", "-c", darkluaConfigPath, targetPath, targetPath })

	print(`darklua: processed {package.name}`)
end

return {
	getPackage = getPackage,
	getPackages = getPackages,
	stagePackages = stagePackages,
	darkluaTransformStep = darkluaTransformStep,
}
