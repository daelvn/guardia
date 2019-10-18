# guardia.v2.guards
Set of guards that come with Guàrdia. Batteries included!<br>
Importing `_<type>` from this module will return a type guard for `<type>`.<br>
Importing `_not_<type>` from this module will return a negated type guard for `<type>`.<br>
## _utype
*[source](source/guardia.v2.guards.moon.html#L_11)*<br>
Underlying type checker for [_type](#_type), also supporting the `__type` metafield
for custom types.
## _type
*[source](source/guardia.v2.guards.moon.html#L_28)*<br>
Type-checking source guard. Has to be manually finalized with [_ps](/guardia.v2.init#_ps).
## _utable
*[source](source/guardia.v2.guards.moon.html#L_34)*<br>
Underlying table checker for [_tableof](#_tableof)
## _tableof
*[source](source/guardia.v2.guards.moon.html#L_45)*<br>
Guard that checks that all elements of a table are of the same type.
## _tostring
*[source](source/guardia.v2.guards.moon.html#L_51)*<br>
[tostring](https://lua.org/whatever#pdf-tostring) transformer guard.
## _tonumber
*[source](source/guardia.v2.guards.moon.html#L_57)*<br>
[tonumber](https://lua.org/whatever#pdf-tonumber) transformer guard.