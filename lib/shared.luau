export type function infer(schema: type)
	assert(schema:is("table"), "requires a table type")

	for key, value in schema:properties() do
		if key:is("singleton") and key:value() == "_infer" and value.read then
			return value.read
		end
	end

	error("shape has no readable 'infer' property")
end

export type function equals_then_else(ty: type, otherTy: type, thenTy: type, elseTy: type): type
    return if ty == otherTy
        then thenTy
        else elseTy
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
