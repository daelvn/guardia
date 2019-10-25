path: guardia
source: guards.moon

# guardia.guards
Set of guards that come with Guàrdia. Batteries included!<br>
Importing `_<type>` from this module will return a type guard for `<type>`.<br>
Importing `_not_<type>` from this module will return a negated type guard for `<type>`.<br>

## \_type

**Signature →** `(string, [function]) -> (...) -> boolean, ...`<br>
Type-checking source guard. Has to be manually finalized with [_ps](/module/guardia.init#_ps).

## \_tableof

**Signature →** `(string, [function]) -> (...) -> boolean, ...`<br>
Guard that checks that all elements of a table are of the same type.

##  \_tostring

**Signature →** `(boolean, ...) -> -> boolean, ...`<br>
[tostring](https://lua.org/whatever#pdf-tostring) transformer guard.

!!! warn
    Since it uses native `tostring` as the transformer function, it
    only supports conversion of one argument, so you would need a
    function that runs `tostring` on every argument passed.

## \_tonumber

**Signature →** `(boolean, ...) -> -> boolean, ...`<br>
[tonumber](https://lua.org/whatever#pdf-tonumber) transformer guard.

!!! warn
    Since it uses native `tonumber` as the transformer function, it
    only supports conversion of one argument, so you would need a
    function that runs `tonumber` on every argument passed.

## NO_TYPICAL

A function to be passed to [_type](#t_ype) or [_tableof](#_tableof) that disables [lua-typical](https://github.com/hoelzro/lua-typical) behavior with the guards.