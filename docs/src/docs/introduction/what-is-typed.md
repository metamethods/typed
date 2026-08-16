# what is typed?

::: caution
library is still under development; use at your own risk
:::

`typed` is a runtime type validation library for luau. if you have used [Zod](https://zod.dev) before, the api should feel a bit familiar: building schemas to define what a value should look like, then be able to validate it against data that comes from arbitrary sources.

## a first glance

```luau
const t = require("typed")

-- define a user schema
const userSchema = t.table({
	username = t.string({
		length = {
			min = 3,
			max = 20,
		},
	}),
	age = t.number({ min = 18 }),
	email = t.optional(t.string({ match = "^.+@.+%..+$" })),
	tags = t.array(t.string()),
})

-- pull out the generated type using the infer type function
type User = t.infer<typeof(userSchema)>

const rawData = {
	username = "alex",
	age = 25,
	email = "alex@example.com",
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

if `rawData` is missing `username`, or `age` is `17`, or `email` doesn't look like an email, `result.ok` is `false` and `result.issues` would tell you exactly what failed -- instead of letting a bad value get dropped with no information, or even worse, having the bad value slip through into the rest of your program.

## at the core

`typed` is made of small set of composable parts

- **base schemas** - `t.any`, `t.literal`, `t.is`
- **builtins** - `t.boolean`, `t.number`, `t.string`, `t.none`, `t.vector`, `t.buffer`, `t.callable`, `t.userdata`
- **structures** - `t.table`, `t.array`, `t.iterable`
- **modifiers** - `t.optional`, `t.transform`
- **combinators** - `t.union`, `t.intersect`

every single schema -- no matter how it was created -- contains the same set of methods you can call: `validate`, `parse`, `unwrapParse`, and `enforce`.

## next steps

- [getting started](./getting-started) - installing `typed` into your project, and learn how to build your first schema
- [guide](../guide/schemas) - learn about how `typed` really works
