export type function infer(schemaTy: type): type
	assert(schemaTy:is("table"), "requires a table type")

	for key, value in schemaTy:properties() do
		if key:is("singleton") and key:value() == "_infer" and value.read then
			return value.read
		end
	end

	error("shape has no readable 'infer' property")
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
