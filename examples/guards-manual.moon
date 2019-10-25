-- source code for the guards manual
import _er, _fn, _ng from require "guardia"
import _type         from require "guardia.guards"

_e_notstring = _er "Didn't get a string!"
_string      = _type "string"
fun          = (x) -> x
print fun _fn _e_notstring _ng _string "a"

import _MyType from require "guardia.guards"
print _MyType setmetatable {}, {__type: "MyType"} -- true, {}:MyType_ng _string ...
