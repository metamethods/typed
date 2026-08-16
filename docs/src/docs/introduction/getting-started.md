# Getting Started

## Installation

`typed` can be installed either by grabbing the rbxm from [Github Releases](https://github.com/metamethods/typed/releases), or using the following command below:

::: code-group

```sh [pesde]
$ pesde add metamethods/typed
```

:::

You can then require it wherever you need it

```luau
const t = require("@path/to/typed")
```

::: tip {no-title}
Do note that i, myself, prefer to use string requires, however you are not required to follow this; using roblox's require by instance works too
:::

## Defining a Schema

A schema describes the shape of a value. We can start with `t.table`, and then describe each field with other schemas included with the library.

```luau
const t = require("typed")

const userSchema = t.table({
    username = t.string({
        length = { min = 3, max = 20 }
    }),
    age = t.number({ min = 18 }),
    email = t.optional(t.string({ match = "^.+@.+%..+$" })),
    tags = t.array(t.string())
})
```

`t.optional(...)` marks `email` as allowed to be `nil` -- all the other fields are required.

## Infering a Type

Every schema you build can be turned into a real luau type with the included `t.infer` type function

```luau
type User = t.infer<typeof(userSchema)>

-- equivalent type if made by hand:
-- type User = {
--     username: string
--     age: number
--     email: string?
--     tags: { string? }
-- }
```

## Validating Data

You can call `.parse()` on the schema with any value -- any value that you don't trust; i.e. data from a remote event, or an http request.

```luau
const rawData = {
    username = "alex",
    age = 25,
    email = "alex@example.com",
    tags = { "admin", "developer" },
}

local result = userSchema.parse(rawData)

if result.ok then
    local user: User = result.value
    print(user.username)
else
    print("failed to validate:", t.formatIssues(result.issues))
end
```

The returned value from `.parse()` is a discriminated union: whether `result.ok` is `true` or `false`, you'll get access to either `value` or `issues` typed with either the schema's generated type or an array of `Issue`s respectively.

Try to pass bad data to see what an failed validation look like

```luau
const badData = {
    username = "al", -- too short
    age = 16, -- below min
    tags = { "admin", 5 }, -- 5 is not a string
}

const result = userSchema.parse(badData)

if not result.ok then
    print(t.formatIssues(result.issues))
end
```

It should print the following

```txt
validate_failed - username: invalid_length - expected string with length at least 3, got 2
tags; at index 2's value: invalid_type - expected string, got number
age: invalid_value - expected number at least 18, got 16
```

## Methods Overview

`typed` schemas expose more than `.parse()`. take a look below to see what you need:

| method                | use it when                                                                                                                                                      |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `.validate(value)`    | If you need to do a pass/fail check with issues; you will not get a parsed value back                                                                            |
| `.parse(value)`       | If you want the validated value back, and putting it through any transformation schemas along the way                                                            |
| `.unwrapParse(value)` | If you are confident the value is valid, you can get the value back immediately, while having it passed through `.parse()`, but it will error if the parse fails |
| `.enforce(value)`     | You already have a `T` and want to assert it so it satifies the schema.                                                                                          |

## next steps

- [Guide: Schemas](../guide/schemas) - A deeper dive into what a schema is
- [Guide: Combinators](../guide/combinators) - All the combinator schemas
- [Guide: Modifiers](../guide/modifiers) - All the modifier schemas
