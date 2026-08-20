export type infer<T> = index<T, "infer">

export type metadata<T> = index<T, "metadata">

export type shape<T> = index<T, "shape">

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
