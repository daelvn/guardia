local _fl, _tr, _ng, _ps, _fn, _er, _st, _e1, _in, _ci, _df, _t, _f
do
  local _obj_0 = require("guardia.v2")
  _fl, _tr, _ng, _ps, _fn, _er, _st, _e1, _in, _ci, _df, _t, _f = _obj_0._fl, _obj_0._tr, _obj_0._ng, _obj_0._ps, _obj_0._fn, _obj_0._er, _obj_0._st, _obj_0._e1, _obj_0._in, _obj_0._ci, _obj_0._df, _obj_0._t, _obj_0._f
end
describe("guàrdia v2", function()
  local _str = _fl(function(x)
    return "string" == type(x)
  end)
  local _tostr = _tr(tostring)
  it("starts a chain #_filter", function()
    local st, ar = _str("a")
    assert.are.equal(true, st)
    assert.are.equal(ar, "a")
    st, ar = _str(3)
    assert.are.equal(false, st)
    return assert.are.equal(ar, 3)
  end)
  it("transforms a chain #_transform", function()
    local st, ar = _tostr(_ng(_str({
      b = 5
    })))
    assert.are.equal(true, st)
    return assert.is.truthy(ar:match("table"))
  end)
  it("gets the status of a chain #_status", function()
    local st = _st(_tostr(_ng(_str({
      b = 5
    }))))
    return assert.are.equal(true, st)
  end)
  it("gets the final value of a chain #_pass #_finalize", function()
    local ar = _fn(_tostr(_ng(_str({
      b = 5
    }))))
    return assert.is.truthy(ar:match("table"))
  end)
  it("throws an error during a chain #error #_e1", function()
    return assert.has.error(function()
      return _e1(_ng(_str({
        b = 5
      })))
    end)
  end)
  it("starts a true chain #_true", function()
    return assert.are.equal(true, _st(_t({
      b = 5
    })))
  end)
  it("starts a false chain #_false", function()
    return assert.are.equal(false, _st(_f({
      b = 5
    })))
  end)
  return it("sets a default value #_default", function()
    assert.are.equal(5, _fn((_df(5))(nil)))
    return assert.are.equal(4, _fn((_df(5))(4)))
  end)
end)
return describe("guàrdia v2 guard", function()
  local _utype, _string, _not_number, _number, _tostring, _tonumber, _Whatever
  do
    local _obj_0 = require("guardia.v2.guards")
    _utype, _string, _not_number, _number, _tostring, _tonumber, _Whatever = _obj_0._utype, _obj_0._string, _obj_0._not_number, _obj_0._number, _obj_0._tostring, _obj_0._tonumber, _obj_0._Whatever
  end
  local make_Whatever
  make_Whatever = function(t)
    return setmetatable(t, {
      __type = "Whatever"
    })
  end
  it("gets a type #_utype", function()
    local getstring = _utype("string")
    assert.are.equal(true, getstring("a"))
    return assert.are.equal(false, getstring(5))
  end)
  it("checks basic types #_type", function()
    assert.has.error(function()
      return _e1(_string(5))
    end)
    assert.are.equal(false, _st(_string("a")))
    assert.has.error(function()
      return _e1(_not_number(5))
    end)
    return assert.are.equal(false, _st(_not_number("a")))
  end)
  it("transforms chains #_tostring #_tonumber", function()
    local ar = _fn(_tostring(_t({
      b = 5
    })))
    assert.truthy(ar:match("table"))
    ar = _fn(_tonumber(_t("5")))
    return assert.are.equal(5, ar)
  end)
  return it("checks custom types #_custom", function()
    local wh = make_Whatever({
      b = 5
    })
    assert.has.error(function()
      return _e1(_Whatever(5))
    end)
    return assert.are.equal(false, _st(_Whatever(wh)))
  end)
end)
