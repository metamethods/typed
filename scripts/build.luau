const process = require("@lune/process")
const serde = require("@lune/serde")
const fs = require("@lune/fs")

const packages = require("./packages")
const paths = require("./paths")
const steps = require("./steps")
const lib = require("./lib")

const packageToBuild = process.args[1]

const targetPackage = packages.getPackage(paths.PACKAGES_DIR, packageToBuild)
const stagedPackages = packages.stagePackages(paths.STAGING_DIR, { targetPackage })

type LuauRcConfig = {
	aliases: {
		[string]: string?,
	},

	[string]: unknown,
}

if lib.pathExists(paths.RBXMS_DIR) then
	fs.removeDir(paths.RBXMS_DIR)
end

fs.writeDir(paths.RBXMS_DIR)

steps.runSteps(stagedPackages, {
	function(package: packages.StagedPackage)
		const luaurcPath = `{package.path}/.luaurc`

		if not lib.pathExists(luaurcPath) then
			return
		end

		const luaurcConfig: LuauRcConfig = serde.decode("json", fs.readFile(luaurcPath))

		if luaurcConfig.aliases["packages"] then
			fs.move(`{package.path}/packages`, `{package.path}/lib/packages`)
			luaurcConfig.aliases.packages = `./lib/packages`
			fs.writeFile(luaurcPath, serde.encode("json", luaurcConfig))
		end
	end,
	packages.darkluaTransformStep,
	function(package: packages.StagedPackage)
		const outputPath = `{package.name}.rbxm`
		lib.run("rojo", { "build", "--output", outputPath }, {
			cwd = package.path,
		})
		fs.move(`{package.path}/{outputPath}`, `{paths.RBXMS_DIR}/{outputPath}`)
	end,
})
