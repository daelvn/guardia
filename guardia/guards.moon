-- guardia.guards
-- By daelvn
import _fl, _tr, _ng, _ps, _fn, _er, _st, _e1 from require "guardia"
gm, sm = getmetatable, setmetatable

BASE_TYPES = {"number", "string", "function", "thread", "userdata", "nil", "boolean", "table"}

NO_TYPICAL = (x) -> type x
_utype     = (ty, t=type) -> (...) ->
  ret = true
  for v in *{...}
    if t != type then ret = ty == t v
    else
      if ("table" == type v) and (gm v) and (gm v).__type
        switch type (gm v).__type
          when "string"   then ret = ty == (gm v).__type
          when "function" then ret = ty == ((gm v).__type)!
          else                 ret = ty == t v
      else ret = ty == t v
    return false unless ret
  return ret
_type = (ty, t=type) -> (...) -> (_fl (_utype ty, t)) ...

_utable = (ty, t=type) -> (...) ->
  for v in *{...}
    return false if "table" != t v
    for e in *v
      return false if ty != t e
  return true
_tableof  = (ty, t=type) -> (...) -> (_fl (_utable ty, t)) ...

_tostring = _tr tostring
_tonumber = _tr tonumber

setmetatable {
  :_type
  :_tableof
  :_tostring
  :_tonumber
  :NO_TYPICAL
}, {
  __index: (i) =>
    if ty = i\match "^_not_(.+)"
      return (...) -> _ng (_type ty) ...
    elseif ty = i\match "^_(.+)"
      return _type ty
    else
      return rawget @, i
}
