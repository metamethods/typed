export type infer<T> = index<T, "infer">

export type metadata<T> = index<T, "metadata">

export type shape<T> = index<T, "shape">

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
