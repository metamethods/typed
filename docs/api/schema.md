# Schema

Everything in `typed` -- `t.string()`, `t.table({ ... })`, `t.union(a, b)`, and i mean everything -- returns the same object: a `Schema<T>`. This page covers it in full since it is the foundation of the `typed` library.

## The Schema Type

```luau
export type Schema<T, S = nil, M = nil> = {
    type: SchemaType,
    infer: T,
   	metadata: M,
    shape: S,
    meta: <T, S, M, NewM>(self: Schema<T, S, M>, metadata: NewM) -> Schema<T, S, NewM>,
    validate: (value: any) -> ValidateResult,
    parse: (value: any) -> ParseResult<T>,
    unwrapParse: (value: any) -> T,
    enforce: (value: T) -> T
}
```

- `T` is the generated type the schema creates when you build our your schemas.
- `S` is the shape the schema defines. Currently it is only used in the table schema.
- `M` is the metadata the schema defines.

## `:meta(metadata)`

Set metadata for the selected schema.

```luau
const formSchema = t.table({
    cardNumber = t.string():meta({
        name = "Card Number",
        description = "The card number you want to use to purchase"
    }),
    cvc = t.number():meta({
        name = "CVC",
        description = "Security code to your card"
    })
})
```

Library authors that use typed to create things, like the example above, can pull out the data by iterating through the shape field thats attached on the schema object. Take this for example:

```luau
const function createForm(formSchema: t.Schema<
    any,
    { [string]: t.Schema<string | number, any, { name: string, description: string }> }
>)
    for key, field in formSchema.shape do
        print(key, `type: {field.type}`, `name: {field.metadata.name}`, `description: {field.metadata.description}`)
    end
end

createForm(formSchema)
```

This prints the following if you ran the code:

```txt
cvc type: number	name: CVC	description: Security code to your card
cardNumber  type: string	name: Card Number	description: The card number you want to use to purchase
```

Of course, you can also use the normal validation methods thats listed below to validate and parse data with the same schema.

::: caution
Currently it directly modifies the schema you are targeting; it does not create a new schema with the metadata you have provided for it hence the reason why it is the only method that uses `:` (colon) syntax instead of `.` (dot) syntax.
:::

## `.validate(value)`

Checks a value against the schema and tells you if it passed.

```luau
const result = t.number({ min = 0 }).validate(-5)

if not result.ok then
    print(t.formatIssues(result.issues))
end
```

This returns a `ValidateResult`:

```luau
type ValidateResult = { ok: true } | { ok: false, issues: { ValidateIssue } }
```

::: tip
Notice how a successful validation carries **no value**, only `{ ok = true }`. Only use this if you just need a yes/no answer if the data you passed in is valid or not.
:::

::: caution
Do not trust the original value after calling `.validate`, since some schemas may implement transformable schemas (e.g `t.transform`) and can change the schema's resulting type. Unless you are sure there isnt one in your schema, use `.parse` to be on the safer side.
:::

## `.parse(value)`

The one you'll probably use the most. Validates the passed value and, if it passes, hands back the (possibly transformed) result.

```luau
const result = userSchema.parse(rawData)

if result.ok then
	const user = result.value -- typed as t.infer<typeof(userSchema)>
	print(user)
else
	print(t.formatIssues(result.issues))
end
```

The method returns a `ParseResult<T>`

```luau
type ParseResult<T> = { ok: true, value: T } | { ok: false, issues: { ParseIssue } }
```

Internally, `.parse` will always run `.validate` first. If the validation fails, you'll get a `ParseResult` with a single `validate_failed` issue which wraps around all the validation issues that occured when validating the value.

## `.unwrapParse(value)`

Runs `.parse` and either returns the parsed value directly or throws an `error(..)` with the formatted issues.

```luau
const user = userSchema.unwrapParse(rawData) -- user, or throws an error
```

Use this at areas where you know **for sure** that the value is valid and error if there is a genuine bug in your program. You can also use this to quickly try out some stuff if you rather not handle the error manually.

## `.enforce(value)`

```luau
enforce: (value: T) -> T
```

This is the one method that does not perform a runtime check -- rather it is here mainly to help easily cast your data to be like your schema. This is mainly used when you are writing the parsed values yourself manually in code and would like to be sure that you are writing the value correctly.

```luau
const tableOfUsers: { t.infer<typeof(userSchema)> } = {
    ...
    userSchema.enforce({
        username = "alex",
        age = 25,
        tag -- the intellisense should tell you that you can complete this to be tags and has the type of { string? }
    })
    ...
}
```
