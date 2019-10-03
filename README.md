# Guàrdia 2 - Function guards for Lua & MoonScript

Guàrdia is a small library in hopes of obsoleting [guard.lua](https://github.com/Yonaba/guard.lua), which is pretty old
already if you ask me. This one, to nobody's surprise, is curried and focused on MoonScript, but hey, you're stil free to
use it in Lua.

## Installation

```
$ luarocks install guardia
```

## Documentation

You can find the documentation over [here.](https://git.daelvn.ga/guardia)

## Changelog

- If you don't want to have to change all of your code, `guardia.v2` provides replacements written using the new terms, so no need to worry about that.
- Functions are now defined in an actually compositive manner.

## Usage

### \_pass / \_finalize

```moon
_ps true, 5 -- 5
```

### \_filter

```moon
_isString = _fl (x) -> "string" == type x
_id       = (x) -> x
id        = (x) -> id _fn _isString x
```

### \_transform

```moon
_toString = _tr tostring
_id       = (x) -> x
id        = (x) -> id _ps _toString (_fl->true) x
```

### \_status

```moon
_isString = _fl (x) -> "string" == type x
print _st _isString 5 -- false
```

### \_negate

```moon
_isString = _fl (x) -> "string" == type x
print _st _ng _isString 5 -- true
```

### \_error

```moon
_isString = _fl (x) -> "string" == type x
_ex = _er "argument is not a string!"
_ex _isString 6 -- Error! argument is not a string!
```

### \_e1

```moon
_isString = _fl (x) -> "string" == type x
_e1 _isString 6 -- guardia $ filter did not pass!
```

### \_default

```moon
print _fn (_df 5) nil -- 5
print _fm (_df 5) 4   -- 4
```

## License

I'm throwing this, as always, to the public domain, do what you want with it.

## Maintainer

Dael [daelvn@gmail.com]

## Goodbye?

goodbye.
