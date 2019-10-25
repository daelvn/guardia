path: examples
source: guards-manual.moon

# Guàrdia Guards Manual

This is a shorter tutorial oriented to understanding [guardia.guards](/module/guardia.guards/) which is a pretty small module for type checking. If you are new to Guàrdia, you should read the [Core Manual](/manual/core/) first.

## Type checking

### General

Normal type checking is done using the [\_type](/module/guardia.guards/#_type) function, which takes a type name and a type function (that defaults to Lua's [type](https://www.lua.org/manual/5.3/manual.html#pdf-type)). Then it returns a [Source](/manual/core/#Chains) that will take any number of arguments and check that they all are of the same type, the one you passed. Since it is a Source, it needs to be finalized using [_fn](/module/guardia.init/#_fn) or similar.

```moon tab="MoonScript"
-- check that we are getting a string, error otherwise
_e_notstring = _er "Didn't get a string!"
_string      = _type "string"
fun _fn _e_notstring _ng _string ...
```

```lua tab="Lua"
-- check that we are getting a string, error otherwise
local _e_notstring = _er("Didn't get a string!")
local _string      = _type("string")
fun(_fn(_e_notstring(_ng(_string(...)))))
```

### Tables

You can check that a table has elements all of the same type by using the [\_tableof](/module/guardia.guards/#_tableof) function, and it works similarly to [\_type](/module/guardia.guards/#_type), also taking a type function optionally. It works with multiple tables, and if any of the arguments is not a table, then `false` will be returned.

### Custom type checking

The purpose of having an optional argument for the `type` function is to provide compatibility with libraries such as [lua-typical](https://github.com/hoelzro/lua-typical) or the always-unreleased [ltypekit](https://github.com/daelvn/ltypekit7). However, and regardless of the type function used, if a Lua table contains a `__type` metafield that is a function or a string, it will be used (mimicking `lua-typical` behavior, if you wish to disable this, pass [NO_TYPICAL](/module/guardia.guards/#NO_TYPICAL) as the type function.)

### Automatic type checker generator

This module lets you import type checkers dynamically so you don't have to define them yourself, so importing `_MyType` from the module will give you a checker for the type "MyType", and importing `_not_MyType` will check for anything but "MyType".

```moon tab="MoonScript"
import _MyType from require "guardia.guards"
_MyType setmetatable {}, {__type: "MyType"} -- true, {}:MyType
```

```lua tab="Lua"
local _MyType = require"guardia.guards"._MyType
_MyType(setmetatable({},{__type="MyType"})) -- true, {}:MyType
```