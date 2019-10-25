# Guàrdia 3 - Function guards for Lua & MoonScript

Guàrdia is a small library in hopes of obsoleting [guard.lua](https://github.com/Yonaba/guard.lua), which is pretty old
already if you ask me. This one, to nobody's surprise, is curried and focused on MoonScript, but hey, you're stil free to use it in Lua.

## Installation

```
$ luarocks install guardia
```

## Documentation

You can find the documentation over [here.](https://git.daelvn.ga/guardia)

## Changelog

## v3

- Removed v2 tests.
- `guardia.v2` becomes simply `guardia`.
- `_type` from `guardia.guards` does not negate the result anymore. This increases clearness.
- Added logical operators in `guardia.init`.
- Added manual.
- Changed the behavior of `_type` as explained in the [Guards Manual](https://git.daelvn.ga/guardia/manual/guards/).
- `_utype` and `_utable` are not exported anymore.
- Removed doc comments from source code.
- Documentation now uses MkDocs.

## v2

- If you don't want to have to change all of your code, `guardia.v2` provides replacements written using the new terms, so no need to worry about that.
- Functions are now defined in an actually compositive manner.

## License

I'm throwing this, as always, to the public domain, do what you want with it.

## Maintainer

Dael [daelvn@gmail.com]

## Goodbye?

goodbye.
