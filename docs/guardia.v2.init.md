# guardia.v2.init
Guards for Lua. Based upon [guard.lua](https://github.com/Yonaba/guard.lua).
This version is rather thought for curried functions and use with MoonScript.
## Sources
Sources are functions that take a set of values and start a guard chain. They're always
of the kind `(...) -> boolean, ...`.
### _filter
*[source](source/guardia.v2.init.moon.html#L_11)*<br>
Alias → `_fl`<br>
Filtering function. If the filter passes, the first returned value is `true`, `false` otherwise.
### _true
*[source](source/guardia.v2.init.moon.html#L_18)*<br>
Alias → `_t`<br>
Starts a chain, always returning `true`.
### _false
*[source](source/guardia.v2.init.moon.html#L_25)*<br>
Alias → `_f`<br>
Starts a chain, always returning `false`.
### _default
*[source](source/guardia.v2.init.moon.html#L_32)*<br>
Alias → `_df`<br>
Makes the value of the chain `a` only if `...` is `nil`.
## Transformers
Transformers are functions which continue a chain, also modifying the arguments that go along
with the boolean. They're always of the kind `(boolean, ...) -> boolean, ...`.
### _transform
*[source](source/guardia.v2.init.moon.html#L_43)*<br>
Alias → `_tr`<br>
Transforms the values being passed through a function, only if the boolean passed is `true`.
### _negate
*[source](source/guardia.v2.init.moon.html#L_50)*<br>
Alias → `_ng`<br>
Negates the status from last operation.
### _error
*[source](source/guardia.v2.init.moon.html#L_57)*<br>
Alias → `_er`<br>
Raises → Error message passed to the function (if boolean is `false`).<br>
Errors with `msg` if the status is `true`.
### _e1
*[source](source/guardia.v2.init.moon.html#L_65)*<br>
Raises → "guardia $ chain was stopped"<br>
Predefined error for [_error](#_error).
### _inspect
*[source](source/guardia.v2.init.moon.html#L_72)*<br>
Alias → `_in`<br>
Prints an inspect count number and every value on the chain, including the boolean.
### _named
*[source](source/guardia.v2.init.moon.html#L_82)*<br>
Alias → `_ci`<br>
Complex inspect. Instead of the inspect count number, prints the message along with every value on the
chain and the status.
## Finalizers
Finalizers are functions that end a guard chain, returning only part of the values. Their form
can either be `(boolean, ...) -> boolean` or `(boolean, ...) -> ...`.
### _pass
*[source](source/guardia.v2.init.moon.html#L_96)*<br>
Alias → `_ps`, `_fn`<br>
Ignores the boolean and returns the varargs.
### _status
*[source](source/guardia.v2.init.moon.html#L_103)*<br>
Alias → `_st`<br>
Returns the status from the chain and nothing else.
## v1 Guards
These guards are v1 replicas made using the new guard functions. They are the closest to
the original `guard.lua`. Most of them take the form `(function) -> (function) -> (function) -> (...) -> ...`.
### Guard
*[source](source/guardia.v2.init.moon.html#L_131)*<br>
Uses a filter and transformer function on a set of values passed to `f`.
### Antiguard
*[source](source/guardia.v2.init.moon.html#L_137)*<br>
Equivalent to [Guard](#Guard), but negates the results of `fl`.
### Biguard
*[source](source/guardia.v2.init.moon.html#L_143)*<br>
Essentially a mix of [Guard](#Guard) and [Antiguard](#Antiguard), so the transformer `tr` runs
when the filter passes, `ar` otherwise.
### Endguard
*[source](source/guardia.v2.init.moon.html#L_150)*<br>
A guard for the result values of the function `f` called with `...`.
### Errguard
*[source](source/guardia.v2.init.moon.html#L_156)*<br>
[Guard](#Guard) but errors if the filter does not pass.
### Enderrguard
*[source](source/guardia.v2.init.moon.html#L_161)*<br>
[Endguard](#Endguard) but errors if the filter does not pass.
### Antierrguard
*[source](source/guardia.v2.init.moon.html#L_166)*<br>
[Antiguard](#Antiguard) but errors if the filter does not pass.