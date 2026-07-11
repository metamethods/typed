> [!CAUTION]
> library is still under development; use at your own risk

# typed

a runtime type validation library for luau

## example

```luau
const t = require("typed")

const schema = t.table({
	hello = t.string(),
	world = t.number(),
})

const data = {
	hello = "hello",
	world = 42,
}

print(schema.parse(data)) -- { ok = true, value = { hello = "hello", world = 42 } }
```

## usage

todo
