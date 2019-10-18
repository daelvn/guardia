--> # guardia.guards
--> Set of guards that come with Guàrdia. Batteries included!<br>
--> Importing `_<type>` from this module will return a type guard for `<type>`.<br>
--> Importing `_not_<type>` from this module will return a negated type guard for `<type>`.<br>
import _fl, _tr, _ng, _ps, _fn, _er, _st, _e1 from require "guardia.v2"
gm, sm = getmetatable, setmetatable

BASE_TYPES = {"number", "string", "function", "thread", "userdata", "nil", "boolean", "table"}

--> ## _utype
--# _utype
--: _utype (string, function) -> (...) -> boolean
--> Underlying type checker for [_type](#_type), also supporting the `__type` metafield
--> for custom types.
_utype = (ty, t=type) -> (...) ->
  ret = true
  for v in *{...}
    if ("table" == t v) and (gm v) and (gm v).__type
      switch t (gm v).__type
        when "string"   then ret = ty == (gm v).__type
        when "function" then ret = ty == ((gm v).__type)!
        else                 ret = ty == t v
    else ret = ty == t v
    return false unless ret
  return ret

--> ## _type
--# _type
--: _type (string, function) -> (...) -> boolean, ...
--> Type-checking source guard. Has to be manually finalized with [_ps](/guardia.v2.init#_ps).
_type = (ty, t=type) -> (...) -> _ng (_fl (_utype ty, t)) ...

--> ## _utable
--# _utable
--: _utable (string, function) -> (...) -> boolean
--> Underlying table checker for [_tableof](#_tableof)
_utable = (ty, t=type) -> (...) ->
  for v in *{...}
    return false if "table" != t v
    for e in *v
      return false if ty != t e
  return true

--> ## _tableof
--# _tableof
--: _tableof (string, function) -> (...) -> ...
--> Guard that checks that all elements of a table are of the same type.
_tableof = (ty, t=type) -> (...) -> _ng (_fl (_utable ty, t)) ...

--> ## _tostring
--# _tostring
--: _tostring (boolean, ...) -> boolean, ...
--> [tostring](https://lua.org/whatever#pdf-tostring) transformer guard.
_tostring = _tr tostring

--> ## _tonumber
--# _tonumber
--: _tonumber (boolean, ...) -> boolean, ...
--> [tonumber](https://lua.org/whatever#pdf-tonumber) transformer guard.
_tonumber = _tr tonumber

setmetatable {
  :_utype
  :_type
  :_utable
  :_tableof
  :_tostring
  :_tonumber
}, {
  __index: (i) =>
    if ty = i\match "^_not_(.+)"
      return (...) -> _ng (_type ty) ...
    elseif ty = i\match "^_(.+)"
      return _type ty
    else
      return rawget @, i
}
