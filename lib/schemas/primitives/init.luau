const result = require("../result")
const issue = require("../issue")
const schema = require("../schema")

const function primitive<T>(typeName: string, validateFn: ((value: any) -> result.ValidateResult)?): schema.Schema<T>
	return schema<<T>>(function(value)
		if type(value) ~= typeName then
			return result.validate.err({
				issue.validate.invalidType(`expected {typeName}, got {typeof(value)}`),
			})
		end

		if validateFn then
			return validateFn(value)
		end

		return result.validate.ok()
	end)
end

const function primitiveFn<T>(typeName: string): () -> schema.Schema<T>
	return function(): schema.Schema<T>
		return primitive<<T>>(typeName)
	end
end

const primitives = {}

primitives.boolean = primitiveFn<<boolean>>("boolean")

type NumberOptions = {
	unbounded: boolean?,
	min: number?,
	max: number?,
}

primitives.number = function(options: NumberOptions?): schema.Schema<number>
	const options: NumberOptions = options or {}

	return primitive<<number>>("number", function(value)
		if not options.unbounded and (math.isnan(value) or math.isinf(value)) then
			return result.validate.err({
				issue.validate.invalidValue(`expected a finite number, got {tostring(value)}`),
			})
		end

		if options.min and value < options.min then
			return result.validate.err({
				issue.validate.invalidValue(`expected number at least {options.min}, got {value}`),
			})
		end

		if options.max and value > options.max then
			return result.validate.err({
				issue.validate.invalidValue(`expected number at most {options.max}, got {value}`),
			})
		end

		return result.validate.ok()
	end)
end

type StringOptions = {
	match: string?,
	length: {
		min: number?,
		max: number?,
	}?,
}

primitives.string = function(options: StringOptions?): schema.Schema<string>
	const options: StringOptions = options or {}

	return primitive<<string>>("string", function(value)
		if options.match and not string.match(value, options.match) then
			return result.validate.err({
				issue.validate.invalidMatch(`expected string matching pattern {options.match}, got {tostring(value)}`),
			})
		end

		if options.length then
			if options.length.min and #value < options.length.min then
				return result.validate.err({
					issue.validate.invalidLength(
						`expected string with length at least {options.length.min}, got {#value}`
					),
				})
			end

			if options.length.max and #value > options.length.max then
				return result.validate.err({
					issue.validate.invalidLength(
						`expected string with length at most {options.length.max}, got {#value}`
					),
				})
			end
		end

		return result.validate.ok()
	end)
end

primitives.table = require("@self/table")

primitives["nil"] = primitiveFn<<nil>>("nil")
primitives.none = primitives["nil"]

primitives.vector = primitiveFn<<vector>>("vector")

primitives.buffer = primitiveFn<<Buffer>>("buffer")

primitives["function"] = primitiveFn<<(...any) -> ...any>>("function")
primitives.callable = primitives["function"]

-- there isnt a type definition for userdata in luau
-- im just gonna keep it as unknown until there is a
-- type definition i can use for it
primitives.userdata = primitiveFn<<unknown>>("userdata")

return primitives
