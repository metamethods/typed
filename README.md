> [!CAUTION]
> library is still under development; use at your own risk

# typed

a runtime type validation library for luau

## example

```luau
const t = require("./lib")

-- define a user schema
const userSchema = t.table({
	username = t.string({
		length = {
			min = 3,
			max = 20,
		},
	}),
	age = t.number({ min = 18 }),
	email = t.optional(t.string({ match = "^.+@.+\..+$" })),
	tags = t.array(t.string()),
})

-- pull out the generated type using the infer type function
type User = t.infer<typeof(userSchema)>

const rawData = {
	username = "alex",
	age = 25,
	email = "test@gamil.com",
	tags = { "admin", "developer" },
}

-- attempt to validate and parse the raw data using the created schema
const result = userSchema.parse(rawData)

if result.ok then
	const user: User = result.value
	print(user)
else
	print("failed to validate:", t.formatIssues(result.issues))
end
```
