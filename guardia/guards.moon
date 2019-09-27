--- Set of guards that come with guardia. Batteries included!
-- @module guardia.guards
-- @author daelvn
import Guard, Antiguard, Biguard, Endguard, Errguard, Antierrguard, Enderrguard from require "guardia"
id     = (...) -> ...
gm, sm = getmetatable, setmetatable

_isType = (ty, t=type) -> (v) ->
  if ("table" == t v) and (gm v).__type
    switch t (gm v).__type
      when "string"   then return ty == (gm v).__type
      when "function" then return ty == ((gm v).__type)!
      else                 return ty == t v
  else return ty == t v
--- Type-checking errguards.
-- `guardia.guards` automatically creates functions such as `getsNumber` or `getsNil` for all Lua base types.
-- It also supports the `__type` metafield for custom types.
-- @tparam string ty Type to check for.
-- @tparam function|nil t Type function to use.
-- @treturn function Function that takes another to guard.
getsType = (ty, t=type) -> (Errguard _isType ty, t) id

_baseTypes  = {"number", "string", "function", "thread", "userdata", "nil", "boolean", "table"}
_capitalize = (v) -> (string.upper string.sub v, 1, 1) .. string.sub v, 2
_typeGuards = {("gets".._capitalize v), (getsType v) for v in *_baseTypes}
import
  getsNumber,
  getsString,
  getsFunction,
  getsThread
  getsUserdata,
  getsNil,
  getsBoolean,
  getsTable from _typeGuards

--- Type-checking enderrguards.
-- `guardia.guards` automatically creates functions such as `expectsNumber` or `expectsNil` for all Lua base types.
-- @tparam string ty Type to check for.
-- @tparam function|nil t Type function to use.
-- @treturn function Function that takes another to guard.
expectsType = (ty, t=type) -> (Enderrguard _isType ty, t) id

_typeEndguards = {("expects".._capitalize v), (expectsType v) for v in *_baseTypes}
import
  expectsNumber,
  expectsString,
  expectsFunction,
  expectsThread
  expectsUserdata,
  expectsNil,
  expectsBoolean,
  expectsTable from _typeGuards
--- Type-checking antierrguards.
-- `guardia.guards` automatically creates functions such as `exceptNumber` or `exceptNil` for all Lua base types.
-- @tparam string ty Type to check for.
-- @tparam function|nil t Type function to use.
-- @treturn function Function that takes another to guard.
exceptType = (ty, t=type) -> (Antierrguard _isType ty, t) id

__typeAntiguards = {("except".._capitalize v), (exceptType v) for v in *_baseTypes}
import
  exceptNumber,
  exceptString,
  exceptFunction,
  exceptThread
  exceptUserdata,
  exceptNil,
  exceptBoolean,
  exceptTable from _typeGuards

--- Forcefully getting a string (using `tostring`). \[Guard\].
-- @treturn function Function that expects another to guard.
getsStringForced = -> (Guard ->true) (v) -> tostring v

--- Checks whether a number passed is odd.
-- @treturn function Function that expects another to guard.
getsOdd = -> (Guard (n)->n%2==0) id

--- Checks whether a number passed is even.
-- @treturn function Function that expects another to guard.
getsEven = -> (Antiguard (n)->n%2==0) id

{
  -- gets
  :getsType
  :getsNumber
  :getsString
  :getsFunction
  :getsThread
  :getsUserdata
  :getsNil
  :getsBoolean
  :getsTable
  -- expects
  :expectsType
  :expectsNumber
  :expectsString
  :expectsFunction
  :expectsThread
  :expectsUserdata
  :expectsNil
  :expectsBoolean
  :expectsTable
  -- except
  :exceptType
  :exceptNumber
  :exceptString
  :exceptFunction
  :exceptThread
  :exceptUserdata
  :exceptNil
  :exceptBoolean
  :exceptTable
  -- other
  :getsStringForced
  :getsOdd, :getsEven
}
