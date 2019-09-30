--- Set of guards that come with Guàrdia. Batteries included!
-- Importing `_<type>` from this module will return a type guard for `<type>`.
-- Importing `_not_<type>` from this module will return a negated type guard for `<type>`.
-- @module guardia.v2.guards
-- @author daelvn
import _fl, _tr, _ng, _ps, _fn, _er, _st, _e1 from require "guardia.v2"
gm, sm = getmetatable, setmetatable

BASE_TYPES = {"number", "string", "function", "thread", "userdata", "nil", "boolean", "table"}

--- Underlying type checker for `_type`
-- It also supports the `__type` metafield for custom types.
-- It has to be manually finalized with `_fn` or `_ps`.
-- @tparam string ty Type to check for
-- @tparam function|nil t Type function to use, defaults to `type`.
-- @treturn boolean Whether it matches the type or not.
_utype = (ty, t=type) -> (...) ->
  ret = true
  for v in *{...}
    if ("table" == t v) and (gm v).__type
      switch t (gm v).__type
        when "string"   then ret = ty == (gm v).__type
        when "function" then ret = ty == ((gm v).__type)!
        else                 ret = ty == t v
    else ret = ty == t v
    return false unless ret
  return ret
--- Type-checking guard.
-- It also supports the `__type` metafield for custom types.
-- It has to be manually finalized with `_fn` or `_ps`.
-- @tparam string ty Type to check for
-- @tparam function|nil t Type function to use, defaults to `type`.
-- @treturn function Guard.
_type = (ty, t=type) -> (...) -> _ng (_fl (_utype ty, t)) ...

--- Underlying table checker for `_tableof`.
-- @tparam string ty Type to check for.
-- @tparam function|nil t Type function to use, defaults to `type`.
-- @treturn boolean Whether it is a table containing only that type or not.
_utable = (ty, t=type) -> (...) ->
  for v in *{...}
    return false if "table" != t v
    for e in *v
      return false if ty != t e
  return true

--- Guard that checks that all elements of a table are of the same type.
_tableof = (ty, t=type) -> (...) -> _ng (_fl (_utable ty, t)) ...

--- `tostring` transformer.
-- @function _tostring
_tostring = _tr tostring

--- `tonumber` transformer.
-- @function _tonumber
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
