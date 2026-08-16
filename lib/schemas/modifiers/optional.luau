const shared = require("../../shared")
const result = require("../../result")
const schema = require("../../schema")
const builtins = require("../builtins")
const union = require("../combinators/union")

const function optionalSchema<T>(innerSchema: T)
	return union(innerSchema, builtins.none())
end

return optionalSchema
