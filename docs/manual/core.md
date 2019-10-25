path: examples
source: core-manual.moon

# Guàrdia Core Manual

This is something like a tutorial for Guàrdia 3. This should give you a basic understanding of how the library works and
how to use it properly.

## Chains

Guàrdia works in chains, that take in any amount of arguments, transform or filter them in some way, and then return
another set of arguments. You can think of it as piping in shells. Each chain starts with a **Source**, continues with a
**Transformer** and ends with a **Finalizer**. All kinds are interchangeable between them when all sources are applied (you
can use \_filter and \_true in the same place).

### Boolean chains

The chains that functions in `guardia.init` deal with always starts and end with a given set of arguments, but in
the middle of the chain, the first element passed/returned is a boolean, dubbed **state**. Therefore, you could make a
text diagram of a chain as `... → boolean, ... → ...`.

### Complex chains

Complex chains (specified in modules such as `guardia.trace`) will still start and end with a given set of arguments,
but the elements passed and returned may not necessarily be `boolean, ...`, unlike boolean chains. They may be
`boolean, string, ...` or even `function, ...`, depending on the module. These are less common and are usually
specialized. Chain **lifters** exist, that are able to convert a common chain into a complex chain (and sometimes the
other way).

### Building a simple chain

#### Getting started

To begin with, we're going to build a simple boolean chain. Open up your favourite REPL and import `guardia`.

```moon tab="MoonScript"
> g = require "guardia"
```

```lua tab="Lua"
> g = require("guardia")
```

The simplest chain we can come up with, but also the most useless, would be one that just starts and ends.

```moon tab="MoonScript"
> g._finalize g._true 5, 6
5, 6
```

```lua tab="Lua"
> g._finalize(g._true(5, 6))
5, 6
```

`_true` just starts a boolean chain where the state is `true`, and passes the same arguments we passed, `5` and `6`.
Then `_finalize` gets rid of the state, just to return the arguments. Right now, the state is irrelevant, which means
we could also write our example as `:::moon g._finalize g._false 5, 6` and it would return the same.

Chains can get long, so Guàrdia provides aliases for each function, which would let us rewrite it as
`:::moon g._fn g._t 5, 6` or `:::moon g._fn g._f 5, 6`.

!!! note
    Usually, we would only import the functions we need and get rid of `g`, but since we are on the REPL, we'll leave it.

If we wanted to look at what's going in between `_finalize` and `_true`, we would see `true, 5, 6`, and we actually can do
that, using `_inspect`, which aliases to `_in`. It just prints whatever it gets passed, and also returns it. Think of it
as `tee` for Guàrdia.

```moon tab="MoonScript"
> g._fn g._in g._t 5, 6
1    true    5    6
5, 6
```

```lua tab="Lua"
> g._fn(g._in(g._t(5,6))))
1    true    5    6
5, 6
```

We might see a number we don't recognize, `1`, that is. Guàrdia keeps track of the times that the function has been
called, so you can keep track of the order of inspections more easily. If you wanted you get fancy, you can replace the
count with your own string, by using the `_named` (`_ci`, for **c**omplex **i**nspect) function. It first takes a string,
and returns a function that acts exactly like `_inspect`, but always prints the string instead.

```moon tab="MoonScript"
> g._fn (g._ci "hewwo") g._t 5, 6
hewwo    true    5    6
5, 6
```

```lua tab="Lua"
> g._fn(g._ci("hewwo")(g._t(5, 6)))
hewwo    true    5    6
5, 6
```

#### Getting spicy

But obviously, we will want to do something with our chain, so let's start with using it for simple checks with the
`_filter` (`_fl`) function. It takes a function, and then returns a source that will run the function with the arguments
passed to it. This is better explained by looking at the actual source.

```moon tab="MoonScript"
_filter = (fl) -> (...) -> if fl ... then true, ... else false, ...
```

```lua tab="Lua"
local _filter = function(fl) return function (...)
  if fl(...) then return true, ... else return false, ... end
end end
```

If `fl(...)` is truthy, then the chain will start with `true, ...`, otherwise with `false, ...`. We can use it with
functions such as:

```moon tab="MoonScript"
is5 = (x) -> x == 5
```

```lua tab="Lua"
local function is5 (x) return x == 5 end
```

And then use it with filter this way:

```moon tab="MoonScript"
> g._fn (g._fl is5) 5, 6
5, 6
```

```lua tab="Lua"
> g._fn((g._fl is5)(5, 6))
5, 6
```

If we were to inspect what was going on in the middle, we would see that the function returns `true`. But why is it not
checking the 6? Well, we only setup our function to take a single argument, so we could modify it to work for any
number of arguments:

```moon tab="MoonScript"
is5 = (...) ->
  args, status = {...}, true
  for arg in *args
    status = false if arg != 5
  return status
```

```lua tab="Lua"
local function is5 (...)
  local args, status = {...}, true
  for i, arg in ipairs(arguments) do
    if arg ~= 5 then status = false end
  end
  return status
end
```

And that would still work. But, what is the point if we are still getting 5 and 6? Well, there is a finalizer named
`_status` (`_st`) that returns the status of the boolean chain, dropping the values.

```moon tab="MoonScript"
> g._st (g._fl is5) 5, 5
true
> g._st (g._fl is5) 5, 6
false
```

```lua tab="Lua"
> g._st((g._fl is5)(5, 5))
true
> g._st((g._fl is5)(5, 6))
false
```

If you need to negate the result of a source, or just negate the status anywhere in a chain, you would use `_negate`
(alias `_ng`).

```moon tab="MoonScript"
> g._st g._ng (g._fl is5) 5, 5
false
```

```lua tab="Lua"
> g._st(g._ng(g._fl(is5)(5,5)))
false
```

#### Getting useful

But wait, isn't this essentially the same than running `is5 5, 6`? Well yes, it is, but `is5` does not compose, and
we are not really doing anything with the information. We have to do something with it, this is when the concept
of **Transformers** comes in.

It's nothing new, you've actually already seen it: `_negate`, `_inspect` and `_named` all fit into the concept of
transformers. They're just functions that get a chain and return another chain. The most important one would possibly be
`_transform` (`_tr`), which takes a function, and then, depending on the status of the function, runs the transformer
or not. This is its source:

```moon tab="MoonScript"
_transform = (tr) -> (b, ...) -> if b then true, tr ... else false, ...
```

```lua tab="Lua"
local _transform = function(tr)
  return function(b, ...)
    if b then
      return true, tr(...)
    else
      return false, ...
    end
  end
end
```

So let's make a function that, say, changes all arguments to 3s.

```moon tab="MoonScript"
to3 = (...) ->
  args = {...}
  return table.unpack for i=1, #args do 3
  -- for those unfamiliar with MoonScript syntax, this essentially creates a table of length #args that only
  -- contains 3s, and then unpacks it and returns all the 3s individually.
```

```lua tab="Lua"
local function to3 (...)
  local args, t = {...}, {}
  for i=1, #args do table.insert(t, 3) end
  return table.unpack(t)
end
```

However, if we were to include this in our chain, it would change all of them indiscriminately:

```moon tab="MoonScript"
> g._fn (g._tr to3) g._t 5, true, "a"
3, 3, 3
```

```lua tab="Lua"
> g._fn(g._tr(to3)(g._t(5, true, "a")))
3, 3, 3
```

We probably would want to change all of them *only* when they meet a certain condition. We can do that with filters! Let's
use our `is5` filter. We know that `_transform` only runs the function when the boolean chain status is true, and
`_filter` precisely sets the status for a chain, so let's combine those together:

```moon tab="MoonScript"
> g._fn (g._tr to3) (g._fl is5) 5, true, "a"
5, true, "a"
> g._fn (g._tr to3) (g._fl is5) 5, 5, 5
3, 3, 3
```

```lua tab="Lua"
> g._fn((g._tr(to3))((g._fl(is5))(5, true, "a")))
5, true, "a"
> g._fn((g._tr(to3))((g._fl(is5))(5, 5, 5)))
3, 3, 3
```

It works! This is essentially all you need to build type checkers, so very simple functions can build something bigger.

#### Getting nasty

Let's say we actually want to build a type checker. Just check that our function is getting a certain argument of a
certain type, decorator-style. First, we would build a filter to check we're getting the type we want. Let's check for
numbers.

```moon tab="MoonScript"
_number = g._fl (x) -> (type x) == "number" -- Mind the use of _fl!
```

```lua tab="Lua"
local _number = g._fl(function(x) return type(x) == "number" end) -- Mind the use of _fl!
```

!!! tip
    `_number` is a `guardia.guards` builtin, and it also automatically checks for a `__type` metafield in tables, so
    you should probably use that instead of building them yourself. They're also automatically generated, which means that
    importing `_Nice` from the `guards` module will create a type checker that checks for the type `Nice`.

!!! warning
    The `_number` function we built is only asking for one argument! Keep this in mind when reading and trying
    examples, and feel free to `import _number from require "guardia.guards"` if you need to use more arguments.

Now, that's very fine and all, but what do we do if we're *not* getting a number? We can use `_error` (`_er`), that
will let us raise an error when something that we don't want to happen, happens. Let's define one:

```moon
> _e_notnumber = g._er "That's not a number!"
```

!!! note
    It is a general convention to define errors as `_e_NAME`, so when people see them in chains, they know that is an
    error.

If we didn't want to write our own error message, you can always use the `_e1` builtin, which is essentially `_er` but
it errors with `"guardia $ chain was stopped"`, in case you want to do quick debugging.

The error will be raised if the status on the chain is true. Sounds about right, except our filter will return `true` *on*
numbers! We don't want to error when we get a number! We will simply use `_negate`. We build our chain like this:
```
> g._fn _e_notnumber g._ng _number 5
5
```

In the case that we don't pass numbers, it will error. We will expand on how to catch those later.

#### Getting a burrito

Yeah yeah the last thing was very fun, but how do I use it with my function? Your first thought might be to just
precede the arguments with it:
```moon
myFunction g._fn _e_notnumber g._ng _number 5
```

But not everyone is going to want to write all that when calling your functions, they expect your function to be
already checking for types. This is where we come up with a really simply solution, which is wrapping.
```moon
_myFunction = => (...) -> @ g._fn _e_notnumber g._ng _number ...
-- this could also be written as
_myFunction = (f) -> (...) -> f g._fn _e_notnumber g._ng _number ...
```

!!! note
    It is also kind of a convention to define your wrappers as `_functionName`, and they should be defined right above
    your function definition, kind of like a type signature. *Kind of*.

Now, every function we pass to `_myFunction` will get its first argument typechecked, and will error if it is not
an argument, we may now define our function as:
```moon
myFunction = _myFunction (x) -> x
```

#### Getting logical

Now, what do we do if we want to check for several conditions as a source? Guàrdia provides the builtins `_or`, `_and`
and `_xor` (and their uncurried counterparts, `_or1`, `_and1` and `_xor1`) that ask for two filters, and return the
unified filter. Say we had a filter equivalent to `is5`, but for 4s (`is4`), we could logically OR them this way:
```moon
_is4or5 = g._or1 (g._fl is4), (g._fl is5)
```

!!! tip
    Most of the time we are inlining chains, so for clarity, you might want to use the uncurried version of the logical
    operators instead of the curried ones.

#### Getting safe

We usually want to check for `nil` in our arguments, and replace it with something else otherwise: a *default* value.
Guàrdia provides a builtin for this named `_default` (`_df`), which only works for the first argument but is good enough
for curried functions. It is basically a wrapper for `_transform` and `_filter` with a `nil` type checker embedded, and
is indeed a source:
```moon
> g._fn (g._df 5) nil
5
```

#### Getting double

Now, we have only done chains with a single transformation and a single filter, but what if we need more? It is as simple
to use `_pass` (alias `_ps`), which discards the status mid-chain and lets you use a filter right after it.

!!! note
    `_pass` is equivalent to `_finalize`, in fact, `_finalize` and `_fn` are just aliases for `_pass`, but they're that
    way so that it is clearer in a chain, but feel free to use only `_pass` or only `_finalize`, they're the same
    function, they're interchangeable.

```moon
> g._fn (g._tr to3) (g._fl arg1is5) g._ps (g._tr to4) (g._fl arg1is6) 5, 7, 9
3, 3, 3
```

(Yes, I know we didn't define many of these functions, but I hope you understand what they do by their name)

#### Wrapping up

That is essentially everything in the core library, which doesn't cover the `guards` library nor others. But it will do
for most cases.
