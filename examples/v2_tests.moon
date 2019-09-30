import _fl, _tr, _ng, _ps, _fn, _er, _st, _e1, _in, _ci, _t, _f from require "guardia.v2"

describe "guàrdia v2", ->
  _str   = _fl (x) -> "string" == type x
  _tostr = _tr tostring
  it "starts a chain #_filter", ->
    st, ar = _str "a"
    assert.are.equal true, st
    assert.are.equal ar,   "a"
    st, ar = _str 3
    assert.are.equal false, st
    assert.are.equal ar,    3

  it "transforms a chain #_transform", ->
    st, ar = _tostr _ng _str b: 5
    assert.are.equal true, st
    assert.is.truthy ar\match "table"

  it "gets the status of a chain #_status", ->
    st = _st _tostr _ng _str b: 5
    assert.are.equal true, st

  it "gets the final value of a chain #_pass #_finalize", ->
    ar = _fn _tostr _ng _str b: 5
    assert.is.truthy ar\match "table"

  it "throws an error during a chain #error #_e1", ->
    assert.has.error -> _e1 _ng _str b: 5

  it "starts a true chain #_true", ->
    assert.are.equal true, _st _t b: 5

  it "starts a false chain #_false", ->
    assert.are.equal false, _st _f b: 5

describe "guàrdia v2 guard", ->
  import _utype, _string, _not_number, _number, _tostring, _tonumber, _Whatever from require "guardia.v2.guards"
  make_Whatever = (t) -> setmetatable t, __type: "Whatever"

  it "gets a type #_utype", ->
    getstring = _utype "string"
    assert.are.equal true,  getstring "a"
    assert.are.equal false, getstring 5

  it "checks basic types #_type", ->
    assert.has.error ->     _e1 _string 5
    assert.are.equal false, _st _string "a"
    assert.has.error ->     _e1 _not_number 5
    assert.are.equal false, _st _not_number "a"

  it "transforms chains #_tostring #_tonumber", ->
    ar = _fn _tostring _t b: 5
    assert.truthy ar\match "table"
    ar = _fn _tonumber _t "5"
    assert.are.equal 5, ar

  it "checks custom types #_custom", ->
    wh = make_Whatever b: 5
    assert.has.error ->     _e1 _Whatever 5
    assert.are.equal false, _st _Whatever wh

describe "guàrdia v2 sign", ->
  import sign from require "guardia.v2.sign"

  it "signs a function #sign", ->
    sign "(a -> b) -> [a] -> [b]"
