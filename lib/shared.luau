export type function pull_type(ty: type, needle: type)
	assert(ty:is("table"), "requires a table type")

	for key, value in ty:properties() do
		if key:is("singleton") and key == needle and value.read then
			return value.read
		end
	end

	error(`failed to pull {needle:value()}`)
end

export type infer<T> = pull_type<T, "infer">

export type metadata<T> = pull_type<T, "metadata">

export type shape<T> = pull_type<T, "shape">

export type function expect_string(ty: type)
	assert(not ty:is("intersection"), "intersection type is not allowed")

	if ty:is("union") then
		for _, componentTy in ty:components() do
			expect_string(componentTy)
		end
	else
		assert(ty:is("singleton") and type(ty:value()) == "string" or ty:is("string"), `expected string, got {ty.tag}`)
	end

	return ty
end

const function joinArrays<T>(...: { T }): { T }
	const result = {}

	for _, array in { ... } do
		for _, value in array do
			table.insert(result, value)
		end
	end

	return result
end

return {
	joinArrays = joinArrays,
}
