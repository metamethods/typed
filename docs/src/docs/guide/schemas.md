# schemas

everything in `typed` -- `t.string()`, `t.table({ ... })`, `t.union(a, b)`, and i mean everything -- returns the same object: a `Schema<T>`. this page covers it in full since it is the foundation of the `typed` library.

## the schema type

```luau
export type Schema<T> = {
    _infer: T,
    validate: (value: any) -> ValidateResult,
    parse: (value: any) -> ParseResult<T>,
    unwrapParse: (value: any) -> T,
    enforce: (value: T) -> T
}
```

`T` is the type the schema describes. `_infer` exists so `T` can live under it which enables `t.infer<typeof(schema)>` to be able to pull out a type from the given schema.

## `.validate(value)`

checks a value against the schema and tells you if it passed.

```luau
const result = t.number({ min = 0 }).validate(-5)

if not result.ok then
    print(t.formatIssues(result.issues))
end
```

this returns a `ValidateResult`:

```luau
type ValidateResult = { ok: true } | { ok: false, issues: { ValidateIssue } }
```

::: tip
notice how a successful validation carries **no value**, only `{ ok = true }`. only use this if you just need a yes/no answer if the data you passed in is valid or not.
:::

::: caution
do not trust the original value after calling `.validate`, since some schemas may implement transformable schemas (e.g `t.transform`) and can change the schema's resulting type. instead use `.parse` to be on the safer side.
:::

## `.parse(value)`

the one you'll probably use the most. validates the passed value and, if it passes, hands back the (possibly transformed) result.

```luau
const result = userSchema.parse(rawData)

if result.ok then
	const user = result.value -- typed as t.infer<typeof(userSchema)>
	print(user)
else
	print(t.formatIssues(result.issues))
end
```

the method returns a `ParseResult<T>`

```luau
type ParseResult<T> = { ok: true, value: T } | { ok: false, issues: { ParseIssue } }
```

internally, `.parse` will always run `.validate` first. if the validation fails, you'll get a `ParseResult` with a single `validate_failed` issue which wraps around all the validation issues that occured when validating the value.

## `.unwrapParse(value)`

runs `.parse` and either returns the parsed value directly or throws an `error(..)` with the formatted issues.

```luau
const user = userSchema.unwrapParse(rawData) -- user, or throws an error
```

use this at areas where you know **for sure** that the value is valid and error if there is a genuine bug in your program. you can also use this to quickly try out some stuff if you rather not handle the error manually.

## `.enforce(value)`

```luau
enforce: (value: T) -> T
```

this is the one method that does not perform a runtime check -- rather it is here mainly to help easily cast your data to be like your schema. this is mainly used when you are writing the parsed values yourself manually in code and would like to be sure that you are writing the value correctly.

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
