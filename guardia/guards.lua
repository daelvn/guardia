local _fl, _tr, _ng, _ps, _fn, _er, _st, _e1
do
  local _obj_0 = require("guardia")
  _fl, _tr, _ng, _ps, _fn, _er, _st, _e1 = _obj_0._fl, _obj_0._tr, _obj_0._ng, _obj_0._ps, _obj_0._fn, _obj_0._er, _obj_0._st, _obj_0._e1
end
local gm, sm = getmetatable, setmetatable
local BASE_TYPES = {
  "number",
  "string",
  "function",
  "thread",
  "userdata",
  "nil",
  "boolean",
  "table"
}
local NO_TYPICAL
NO_TYPICAL = function(x)
  return type(x)
end
local _utype
_utype = function(ty, t)
  if t == nil then
    t = type
  end
  return function(...)
    local ret = true
    local _list_0 = {
      ...
    }
    for _index_0 = 1, #_list_0 do
      local v = _list_0[_index_0]
      if t ~= type then
        ret = ty == t(v)
      else
        if ("table" == type(v)) and (gm(v)) and (gm(v)).__type then
          local _exp_0 = type((gm(v)).__type)
          if "string" == _exp_0 then
            ret = ty == (gm(v)).__type
          elseif "function" == _exp_0 then
            ret = ty == ((gm(v)).__type)()
          else
            ret = ty == t(v)
          end
        else
          ret = ty == t(v)
        end
      end
      if not (ret) then
        return false
      end
    end
    return ret
  end
end
local _type
_type = function(ty, t)
  if t == nil then
    t = type
  end
  return function(...)
    return (_fl((_utype(ty, t))))(...)
  end
end
local _utable
_utable = function(ty, t)
  if t == nil then
    t = type
  end
  return function(...)
    local _list_0 = {
      ...
    }
    for _index_0 = 1, #_list_0 do
      local v = _list_0[_index_0]
      if "table" ~= t(v) then
        return false
      end
      for _index_1 = 1, #v do
        local e = v[_index_1]
        if ty ~= t(e) then
          return false
        end
      end
    end
    return true
  end
end
local _tableof
_tableof = function(ty, t)
  if t == nil then
    t = type
  end
  return function(...)
    return (_fl((_utable(ty, t))))(...)
  end
end
local _tostring = _tr(tostring)
local _tonumber = _tr(tonumber)
return setmetatable({
  _type = _type,
  _tableof = _tableof,
  _tostring = _tostring,
  _tonumber = _tonumber,
  NO_TYPICAL = NO_TYPICAL
}, {
  __index = function(self, i)
    do
      local ty = i:match("^_not_(.+)")
      if ty then
        return function(...)
          return _ng((_type(ty))(...))
        end
      else
        do
          ty = i:match("^_(.+)")
          if ty then
            return _type(ty)
          else
            return rawget(self, i)
          end
        end
      end
    end
  end
})
