local _er, _fn, _ng
do
  local _obj_0 = require("guardia")
  _er, _fn, _ng = _obj_0._er, _obj_0._fn, _obj_0._ng
end
local _type
_type = require("guardia.guards")._type
local _e_notstring = _er("Didn't get a string!")
local _string = _type("string")
local fun
fun = function(x)
  return x
end
print(fun(_fn(_e_notstring(_ng(_string("a"))))))
local _MyType
_MyType = require("guardia.guards")._MyType
return print(_MyType(setmetatable({ }, {
  __type = "MyType"
})))
