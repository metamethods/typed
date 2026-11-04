const packages = require("./packages")
const paths = require("./paths")
const steps = require("./steps")
const lib = require("./lib")

const indexedPackages = packages.getPackages(paths.PACKAGES_DIR)
const stagedPackages = packages.stagePackages(paths.STAGING_DIR, indexedPackages)

steps.runSteps(stagedPackages, {
	packages.darkluaTransformStep,
	function(package: packages.StagedPackage)
		print("publish:", package.name)

		const result = lib.run("embr", { "publish" }, {
			mustRun = false,
			cwd = package.path,
		})

		if not result.ok then
			warn("publish:", package.name, "failed to publish; skipping")
		end
	end,
})
