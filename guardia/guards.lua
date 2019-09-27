local Guard, Antiguard, Biguard, Endguard, Errguard, Antierrguard, Enderrguard
do
  local _obj_0 = require("guardia")
  Guard, Antiguard, Biguard, Endguard, Errguard, Antierrguard, Enderrguard = _obj_0.Guard, _obj_0.Antiguard, _obj_0.Biguard, _obj_0.Endguard, _obj_0.Errguard, _obj_0.Antierrguard, _obj_0.Enderrguard
end
local id
id = function(...)
  return ...
end
local gm, sm = getmetatable, setmetatable
local _isType
_isType = function(ty, t)
  if t == nil then
    t = type
  end
  return function(v)
    if ("table" == t(v)) and (gm(v)).__type then
      local _exp_0 = t((gm(v)).__type)
      if "string" == _exp_0 then
        return ty == (gm(v)).__type
      elseif "function" == _exp_0 then
        return ty == ((gm(v)).__type)()
      else
        return ty == t(v)
      end
    else
      return ty == t(v)
    end
  end
end
local getsType
getsType = function(ty, t)
  if t == nil then
    t = type
  end
  return (Errguard(_isType(ty, t)))(id)
end
local _baseTypes = {
  "number",
  "string",
  "function",
  "thread",
  "userdata",
  "nil",
  "boolean",
  "table"
}
local _capitalize
_capitalize = function(v)
  return (string.upper(string.sub(v, 1, 1))) .. string.sub(v, 2)
end
local _typeGuards
do
  local _tbl_0 = { }
  for _index_0 = 1, #_baseTypes do
    local v = _baseTypes[_index_0]
    _tbl_0[("gets" .. _capitalize(v))] = (getsType(v))
  end
  _typeGuards = _tbl_0
end
local getsNumber, getsString, getsFunction, getsThread, getsUserdata, getsNil, getsBoolean, getsTable
getsNumber, getsString, getsFunction, getsThread, getsUserdata, getsNil, getsBoolean, getsTable = _typeGuards.getsNumber, _typeGuards.getsString, _typeGuards.getsFunction, _typeGuards.getsThread, _typeGuards.getsUserdata, _typeGuards.getsNil, _typeGuards.getsBoolean, _typeGuards.getsTable
local expectsType
expectsType = function(ty, t)
  if t == nil then
    t = type
  end
  return (Enderrguard(_isType(ty, t)))(id)
end
local _typeEndguards
do
  local _tbl_0 = { }
  for _index_0 = 1, #_baseTypes do
    local v = _baseTypes[_index_0]
    _tbl_0[("expects" .. _capitalize(v))] = (expectsType(v))
  end
  _typeEndguards = _tbl_0
end
local expectsNumber, expectsString, expectsFunction, expectsThread, expectsUserdata, expectsNil, expectsBoolean, expectsTable
expectsNumber, expectsString, expectsFunction, expectsThread, expectsUserdata, expectsNil, expectsBoolean, expectsTable = _typeGuards.expectsNumber, _typeGuards.expectsString, _typeGuards.expectsFunction, _typeGuards.expectsThread, _typeGuards.expectsUserdata, _typeGuards.expectsNil, _typeGuards.expectsBoolean, _typeGuards.expectsTable
local exceptType
exceptType = function(ty, t)
  if t == nil then
    t = type
  end
  return (Antierrguard(_isType(ty, t)))(id)
end
local __typeAntiguards
do
  local _tbl_0 = { }
  for _index_0 = 1, #_baseTypes do
    local v = _baseTypes[_index_0]
    _tbl_0[("except" .. _capitalize(v))] = (exceptType(v))
  end
  __typeAntiguards = _tbl_0
end
local exceptNumber, exceptString, exceptFunction, exceptThread, exceptUserdata, exceptNil, exceptBoolean, exceptTable
exceptNumber, exceptString, exceptFunction, exceptThread, exceptUserdata, exceptNil, exceptBoolean, exceptTable = _typeGuards.exceptNumber, _typeGuards.exceptString, _typeGuards.exceptFunction, _typeGuards.exceptThread, _typeGuards.exceptUserdata, _typeGuards.exceptNil, _typeGuards.exceptBoolean, _typeGuards.exceptTable
local getsStringForced
getsStringForced = function()
  return (Guard(function()
    return true
  end))(function(v)
    return tostring(v)
  end)
end
local getsOdd
getsOdd = function()
  return (Guard(function(n)
    return n % 2 == 0
  end))(id)
end
local getsEven
getsEven = function()
  return (Antiguard(function(n)
    return n % 2 == 0
  end))(id)
end
return {
  getsType = getsType,
  getsNumber = getsNumber,
  getsString = getsString,
  getsFunction = getsFunction,
  getsThread = getsThread,
  getsUserdata = getsUserdata,
  getsNil = getsNil,
  getsBoolean = getsBoolean,
  getsTable = getsTable,
  expectsType = expectsType,
  expectsNumber = expectsNumber,
  expectsString = expectsString,
  expectsFunction = expectsFunction,
  expectsThread = expectsThread,
  expectsUserdata = expectsUserdata,
  expectsNil = expectsNil,
  expectsBoolean = expectsBoolean,
  expectsTable = expectsTable,
  exceptType = exceptType,
  exceptNumber = exceptNumber,
  exceptString = exceptString,
  exceptFunction = exceptFunction,
  exceptThread = exceptThread,
  exceptUserdata = exceptUserdata,
  exceptNil = exceptNil,
  exceptBoolean = exceptBoolean,
  exceptTable = exceptTable,
  getsStringForced = getsStringForced,
  getsOdd = getsOdd,
  getsEven = getsEven
}
