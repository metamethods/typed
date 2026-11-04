export type Step<T> = (T) -> ()

const function runSteps<T>(stagedPackages: { T }, steps: { Step<T> })
	for _, step in steps do
		for _, stagedPackage in stagedPackages do
			step(stagedPackage)
		end
	end
end

return {
	runSteps = runSteps,
}
