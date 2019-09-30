# Guàrdia - function guards for Lua & MoonScript

Guàrdia is a small library in hopes of obsoleting [guard.lua](https://github.com/Yonaba/guard.lua), which is pretty old
already if you ask me. This one, to nobody's surprise, is curried and focused on MoonScript, but hey, you're stil free to
use it in Lua.

## Installation

```
$ luarocks install guardia
```

## Types of guards.

### Guard

The normal, everyday Guard. Gets a filter, transforming function, then a function to guard and returns it.
```moon
gets3 = (Guard (n) -> n == 2) (n) -> n + 1
id    = (x)                       -> x

print (gets3 id) 2 --> 3
print (gets3 id) 5 --> 5
```

### Antiguard

The opposite to a Guard, runs when it does not pass.
```moon
except2 = (Guard (n) -> n == 2) (n) -> n + 1
id      = (x)                       -> x

print (except2 id) 2 --> 2
print (except2 id) 5 --> 6
```

### Biguard

Both a Guard and an Antiguard. If the filter passes, runs the first transformer, otherwise the second.
```moon
bi2 = (Biguard (n) -> n == 2) ((n) -> n + 1), ((n) -> n - 1)
id  = (x) -> x

print (bi2 id) 2 --> 3
print (bi2 id) 5 --> 4
```

### Endguard

A Guard at the end of the function.
```moon
end2 = (Endguard (n) -> n == 2) (n) -> n + 1

print (end2 -> 2) --> 3
print (end2 -> 5) --> 5
```

### Errguard, Antierrguard, Enderrguard

These are essentially the same as their counterparts, except that if the filter logic does not pass, it throws an error.
```moon
id    = (x) -> x
erru2 = (Errguard (n) -> (n == 2), "number is not 2") id

print (erru2 id) 2 --> 2
print (erru2 id) 5 --> ERROR, number is not 2
```

## Composing guards.

You have two ways of composing guards. One is to just call them one after another.
```moon
f = gets3 getsNumber (n) -> n
```

You can also compose them using the provided `compose` function.
```moon
grd = compose getsNumber, gets3
f   = grd (n) -> n
```

## Included guards.

`guardia.guard` has some guards, mostly type checking.

### getsType

You can pass a string containing the type you want to match and optionally a type function to check it (defaults to Lua's
`type`). It automatically generates functions for all basic lua types such as `getsString`.
```moon
f = (getsType "string") (s) -> s
f = getsString (s) -> s
```

### expectsType

Same as the last one, but as an endguard.
```moon
f = (expectsType "string") (s) -> s
f = expectsString (s) -> s
```

### exceptType

Same as the last one, too, but as antiguards.
```moon
f = (exceptType "string") (a) -> a
f = exceptString (a) -> a
```

### getsStringForced

This one will just turn any argument into a string.
```
f = getsStringForced (a) -> a
print f {} -- table 0xWHATEVER
```

### getsOdd

Just asking for an odd number.

### getsEven

And this one for an even number.

## License

I'm throwing this, as always, to the public domain, do what you want with it.

## Full documentation

[here.](https://git.daelvn.ga/guardia/)

## Maintainer

Dael \<daelvn@gmail.com\>

## Goodbye?

goodbye.
