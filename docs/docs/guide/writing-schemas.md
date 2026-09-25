# Writing Schemas

In order for you to validate data, you must define a schema. From using the smaller, more primitive schemas, you can build larger, more complex schemas.

## Schemas

### Base

```luau
const t = require("typed")

t.any()
t.unknown()
t.never()
t.literal<<"typed">>("typed")
t.literals<<"typed" | "is" | "cool">>("typed", "is", "cool")
t.is<<string>>("string")
t.refine(t.string())(function() ... end)
t.meta(t.string(), "hello world")
```

### Builtins

```luau
t.boolean()
t.number()
t.string()
t["nil"]()
t.none() -- alias of t["nil"]
t.vector()
t.buffer()
t["function"]()
t.callable() -- alias of t["function"]
t.userdata()
```

### Structures

```luau
t.table({ a = t.number() })
t.array(t.string())
t.iterable(t.string(), t.boolean())
```

### Modifiers

```luau
t.optional(t.string())
t.transform(t.string())(function(value)
    return tonumber(value)
end)
t.default(t.string(), "typed")
```

### Combinators

```luau
t.union(t.string(), t.number())
t.intersect(t.table({ a = t.string() }), t.table({ b = t.number() }))
```

## Any, Unknown, and Never

To closely match the types Luau has, `t.any`, `t.unknown`, and `t.never` are all provided. `t.any()` behaves the same as `t.unknown()` at runtime, just that they have different inferred types.

```luau
t.any() -- gets inferred as `any`
t.unknown() -- gets inferred as `unknown`
t.never() -- gets inferred as `never`
```

Parsing data

```luau
t.any().parse("typed") -- pass
t.unknown().parse("is") -- pass
t.never().parse("terrible") -- fail, invalid_type issue
```

::: caution
Do note that `t.never()` will never have a value that will pass validation; it will always return an `invalid_type` issue
:::

## Literal and Literals

`t.literal()` checks a value against a single exact value, using `==`.

```luau
local schema = t.literal<<"typed">>("typed")

schema.parse("typed") -- pass
schema.parse("yped") -- fail (value does not equal "typed")
```

If you want to check against multiple literals, you can use `t.literals()` instead.

```luau
local schema = t.literals<<"typed" | "is" | "cool">>("typed", "is", "cool")

schema.parse("typed") -- pass
schema.parse("is") -- pass
schema.parse("terrible") -- fail (does not exist in the defined literals above)
```

::: note
Due to type widening, without using generic instantiation, it will infer the schema to be a `string` instead of your more narrow type of `"typed" | "is" | "cool"`. There isn't a way--at the moment--to disable this widening property, so you will need to manually use generic instantation in order to get more narrow types upon parsing the schema. If you don't really care about it being widen to a `string` type, then, uhh.. ignore this lol
:::

## Is

`t.is<T>()` checks a value against a `type()` name you provide, and types the result as `T`.

```luau
local schema = t.is<<string>>("string")

schema.parse("typed") -- pass
schema.parse(123) -- fail (number is not type string)
```

::: caution
`T` is not checked at runtime due to it being a type-level annotation for what the schema should be inferring to. Keep them the same to avoid type issues.
:::

## Refine

`t.refine(schema)(refineFn)` allows you to do a custom check during when parsing the schema.

```luau
const numericString = t.refine(t.string())(function(value, result)
    if not tonumber(value) then
        return result.err("not a numeric string")
    end

    return result.ok()
end)
```

## Meta

`t.meta(schema, metadata)` method allows you to wrap around a schema with some metadata attached

```luau
const metaSchema = t.meta(t.string(), "i heart typed")

print(metaSchema.metadata)
```

## Boolean

```luau
t.boolean().parse(true) -- pass
t.boolean().parse(false) -- pass
t.boolean().parse("true") -- fail
```

## Number

`t.number()` only allows finite numbers by default.

```luau
const schema = t.number()

schema.parse(123) -- pass
schema.parse(math.huge) -- fail
schema.parse(0/0) -- fail
```

Customize it with:

```luau
t.number({
    unbounded = true, -- to allow NaN or infinite values
    min = -10,
    max = 100
})
```

## String

```luau
local schema = t.string()

schema.parse("typed") -- pass
schema.parse(123) -- fail
schema.parse(true) -- fail
```

Customize it with:

```luau
t.string({
    match = "^.+@.+%..+$",
    length = {
        min = 10,
        max = 100
    }
})
```

## Nil / None

```luau
t.none().parse(nil) -- pass
t.none().parse("typed") -- fail (not type of nil)
```

## Vector

```luau
t.vector().parse(vector.create(1, 2, 3))
```

## Buffer

```luau
t.buffer().parse(buffer.create(10))
```

## Function / Callable

```luau
t.callable().parse(function() end)
```

## Userdata

```luau
t.userdata().parse(game)
```

## Table

```luau
const person = t.table({
    name = t.string(),
    age = t.number()
})
```

By default, extra keys on the input value are silently stripped from the parsed result:

```luau
person.unwrapParse({
    name = "John",
    lastName = "Doe",
    age = 30
})
-- results in { name = "John", age = 30 }
```

If you want extra keys to be a validation error instead of silently dropped, pass `strict = true`:

```luau
local strictPerson = t.table({
	name = t.string(),
	age = t.number(),
}, { strict = true })

strictPerson.unwrapParse({ name = "John", lastName = "Doe", age = 30 })
-- errors: extra_key issue on "lastName"
```

## Iterable

`t.iterable(keySchema, valueSchema)` validates a table where every key matches `keySchema` and every value matches `valueSchema`.

```luau
local ages = t.iterable(t.string(), t.number())
-- { [string]: number? }

ages.parse({ alex = 25, sam = 30 }) -- pass
ages.parse({ [1] = 25 }) -- fail (key 1 is not a string)
```

`t.array(valueSchema)` is `t.iterable` specialized to number keys:

```luau
t.array(t.string())
-- equivalent to: t.iterable(t.number(), t.string())
```

## Optional

`t.optional(innerSchema)` is a union of the inner schema with `t.none()`.

```luau
local schema = t.optional(t.string())

schema.parse("typed") -- pass
schema.parse(nil) -- pass
schema.parse(123) -- fail
```

## Transform

`t.transform(innerSchema)(transformFn)` validates against `innerSchema` first, then, only if that passes, runs `transformFn` on the value and returns _its_ result instead.

```luau
local numericString = t.transform(t.string())(function(value)
	return tonumber(value) or 0
end)

numericString.parse("42") -- pass, and returns a value with a number type instead of a string type
numericString.parse(true) -- fails, boolean is not a string
```

## Default

`t.default(schema, defaultValue)` automatically makes the input schema optional and able to provide a default value if the value being parsed is nil

```luau
const defaultedSchema = t.default(t.string(), "nuh uh")

defaultedSchema.parse(nil) -- returns "nuh uh"
defaultedSchema.parse("yuh uh") -- returns "yuh uh"
```

## Union

`t.union(schemaA, schemaB)` passes if the value satisfies _either_ schema.

```luau
local schema = t.union(t.string(), t.number())

schema.parse("typed") -- pass
schema.parse(123) -- pass
schema.parse(true) -- fail
```

## Intersect

`t.intersect(schemaA, schemaB)` passes if the value satisfies _both_ schemas, and merges the parsed results together. It's built for combining `t.table` schemas.

```luau
local named = t.table({ a = t.string() })
local aged = t.table({ b = t.number() })

local schema = t.intersect(named, aged)

schema.parse({ a = "typed", b = 1 }) -- pass, { a = "typed", b = 1 }
```

If both schemas parse a value for the _same_ key, that's a conflict:

```luau
local overlapping = t.table({ a = t.string() })
schema = t.intersect(overlapping, overlapping)

schema.parse({ a = "typed" }) -- fail: key_conflict on "a"
```
