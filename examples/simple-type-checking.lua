local guardia = require("guardia")
guardia.guards = require("guardia.guards")
local id
id = function(x)
  return x
end
local _fn, _or1, _er, _ng
_fn, _or1, _er, _ng = guardia._fn, guardia._or1, guardia._er, guardia._ng
local _string, _not_string
do
  local _obj_0 = guardia.guards
  _string, _not_string = _obj_0._string, _obj_0._not_string
end
print(type(id(_fn(_string(5)))))
local _tostring
_tostring = guardia.guards._tostring
print(type(id(_fn(_tostring(_not_string(5))))))
local _number
_number = guardia.guards._number
print(type(id(_fn((_or1(_string, _number))(5)))))
local _e_myerror = _er("myerror: not a string or number")
print(type(id(_fn(_e_myerror(_ng((_or1(_string, _number))(5)))))))
local _boolean
_boolean = guardia.guards._boolean
local _ps = _fn
print(type(id(_fn(_tostring(_boolean(_ps(_tostring(_number({ })))))))))
print(type(id(_fn(_tostring(_boolean(_ps(_tostring(_number(5)))))))))
return print(type(id(_fn(_tostring(_boolean(_ps(_tostring(_number(true)))))))))
