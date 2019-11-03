local g = require("guardia")
print(g._finalize(g._true(5, 6)))
print(g._finalize(g._false(5, 6)))
print(g._fn(g._t(5, 6)))
print(g._fn(g._f(5, 6)))
print(g._fn(g._in(g._t(5, 6))))
print(g._fn((g._ci("hewwo"))(g._t(5, 6))))
local is5
is5 = function(...)
  local args, status = {
    ...
  }, true
  for _index_0 = 1, #args do
    local arg = args[_index_0]
    if arg ~= 5 then
      status = false
    end
  end
  return status
end
print(g._st((g._fl(is5))(5, 5)))
print(g._st((g._fl(is5))(5, 6)))
print(g._st(g._ng((g._fl(is5))(5, 5))))
local to3
to3 = function(...)
  local args = {
    ...
  }
  return table.unpack((function()
    local _accum_0 = { }
    local _len_0 = 1
    for i = 1, #args do
      _accum_0[_len_0] = 3
      _len_0 = _len_0 + 1
    end
    return _accum_0
  end)())
end
print(g._fn((g._tr(to3))(g._t(5, true, "a"))))
print(g._fn((g._tr(to3))((g._fl(is5))(5, true, "a"))))
print(g._fn((g._tr(to3))((g._fl(is5))(5, 5, 5))))
local _number = g._fl(function(x)
  return (type(x)) == "number"
end)
local _e_notnumber = g._er("That's not a number!")
print(g._fn(_e_notnumber(g._ng(_number(5)))))
local _myFunction
_myFunction = function(self)
  return function(...)
    return self(g._fn(_e_notnumber(g._ng(_number(...)))))
  end
end
local myFunction = _myFunction(function(x)
  return x
end)
local _is4or5 = g._or1((g._fl(is4)), (g._fl(is5)))
return print(g._fn((g._df(5))(nil)))
