local schema = require("../../schema")
const primitive = require("./primitive")

const function isSchemaBuilder<T>(typeName: schema.SchemaType)
	return primitive<<T>>(typeName)
end

return isSchemaBuilder
