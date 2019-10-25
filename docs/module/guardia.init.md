path: guardia
source: init.moon

# guardia.init

Guards for Lua. Based upon [guard.lua](https://github.com/Yonaba/guard.lua).
This version is rather thought for curried functions and use with MoonScript.

## Sources

Sources are functions that take a set of values and start a guard chain. They're always
of the kind `(...) -> boolean, ...`.

### \_filter

**Signature →** `(function) -> (...) -> boolean, ...`<br>
**Alias →** `_fl`<br>
Filtering function. If the filter passes, the first returned value is `true`, `false` otherwise.

### \_true

**Signature →** `(...) -> boolean, ...`<br>
**Alias →** `_t`<br>
Starts a chain, always returning `true`.

### \_false

**Signature →** `(...) -> boolean, ...`<br>
**Alias →** `_f`<br>
Starts a chain, always returning `false`.

### \_default

**Signature →** `(v) -> (...) -> boolean, ...`<br>
**Alias →** `_df`<br>
Makes the value of the chain `a` only if the first argument is `nil`.

## Transformers

Transformers are functions which continue a chain, also modifying the arguments that go along
with the boolean. They're always of the kind `(boolean, ...) -> boolean, ...`.

### \_transform

**Signature →** `(function) -> (boolean, ...) -> boolean, ...`<br>
**Alias →** `_tr`<br>
Transforms the values being passed through a function, only if the boolean passed is `true`.

### \_negate

**Signature →** `(boolean, ...) -> boolean, ...`<br>
**Alias →** `_ng`<br>
Negates the status from last operation.

### \_error

**Signature →** `(msg:string) -> (boolean, ...) -> false, ...`<br>
**Alias →** `_er`<br>
**Raises →** Error message passed to the function (if boolean is `true`).<br>
Errors with `msg` if the status is `true`.

### \_e1

**Signature →** `(boolean, ...) -> false, ...`<br>
**Raises →** "guardia $ chain was stopped"<br>
Predefined error for [_error](#_error).

### \_inspect

**Signature →** `(boolean, ...) -> boolean, ...`<br>
**Alias →** `_in`<br>
Prints an inspect count number and every value on the chain, including the boolean.

### \_named

**Signature →** `(boolean, ...) -> boolean, ...`<br>
**Alias →** `_ci`<br>
Complex inspect. Instead of the inspect count number, prints the message along with every value on the
chain and the status.

## Finalizers

Finalizers are functions that end a guard chain, returning only part of the values. Their form
can either be `(boolean, ...) -> boolean` or `(boolean, ...) -> ...`.

### \_pass

**Signature →** `(boolean, ...) -> ...`<br>
**Alias →** `_ps`, `_fn`<br>
Ignores the boolean and returns the varargs.

### \_status

**Signature →** `(boolean, ...) -> boolean`<br>
**Alias →** `_st`<br>
Returns the status from the chain and nothing else.

## Logic operators

Basically wrappers that allow you to OR, AND, XOR, etc. various sources. These technically count as sources.

### \_or

**Signature →** `(function) -> (function) -> function`<br>
ORs two sources.

### \_or1

**Signature →** `(function, function) -> function`<br>
Uncurried [_or](#_or).

### \_and

**Signature →** `(function) -> (function) -> function`<br>
ANDs two sources.

### \_and1

**Signature →** `(function, function) -> function`<br>
Uncurried [_and](#_and).

### \_xor

**Signature →** `(function) -> (function) -> function`<br>
XORs two sources.

### \_xor1

**Signature →** `(function, function) -> function`<br>
Uncurried [_xor](#_xor).

## v1 Guards

These guards are v1 replicas made using the new guard functions. They are the closest to
the original `guard.lua`. Most of them take the form `(function) -> (function) -> (function) -> (...) -> ...`.

### Guard

**Signature →** `(fl:function) -> (tr:function) -> (f:function) -> (...) -> ...`<br>
Uses a filter and transformer function on a set of values passed to `f`.

### Antiguard

**Signature →** `(fl:function) -> (tr:function) -> (f:function) -> (...) -> ...`<br>
Equivalent to [Guard](#Guard), but negates the results of `fl`.

### Biguard

**Signature →** `(fl:function) -> (tr:function, ar:function) -> (f:function) -> (...) -> ...`<br>
Essentially a mix of [Guard](#Guard) and [Antiguard](#Antiguard), so the transformer `tr` runs
when the filter passes, `ar` otherwise.

### Endguard

**Signature →** `(fl:function) -> (tr:function) -> (f:function) -> (...) -> ...`<br>
A guard for the result values of the function `f` called with `...`.

### Errguard

[Guard](#Guard) but errors if the filter does not pass.

### Enderrguard

[Endguard](#Endguard) but errors if the filter does not pass.

### Antierrguard

[Antiguard](#Antiguard) but errors if the filter does not pass.

