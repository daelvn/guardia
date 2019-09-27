--- Guards for Lua. Based upon [guard.lua](https://github.com/Yonaba/guard.lua).
-- This version is rather thought for curried functions and use with MoonScript.
-- @module guardia.init
-- @author daelvn
unpack or= table.unpack

--- guard.lua-style Guard. **Curried function.**
-- @tparam function filter Filters whether the guard is applicable or not.
-- @tparam function transform If the guard is applicable, apply it and return.
-- @tparam function f Function to be guarded.
-- @param ... Arguments to pass to `f`
-- @return Result of `f` or nil, if guarded.
Guard = (filter=->true) -> (transform) -> (f) -> (...) ->
  return ... unless filter ...
  argl = {transform ...}
  f unpack argl

--- Guard that transforms when it does not pass the filter. **Curried function.**
-- @tparam function filter Filters whether the guard is applicable or not.
-- @tparam function transform If the guard is applicable, apply it and return.
-- @tparam function f Function to be guarded.
-- @param ... Arguments to pass to `f`
-- @return Result of `f` or nil, if not guarded.
Antiguard = (filter=->false) -> (transform) -> (f) -> (...) ->
  return ... if filter ...
  argl = {transform ...}
  f unpack argl

--- Guard with two transformers, one if the filte passes, one if it doesn't. **Curried function.**
-- @tparam function filter Filters whether the guard is applicable or not.
-- @tparam function transform If the guard is applicable, apply it and return.
-- @tparam function antitransform If the guard is not applicable, apply this one and return. **Passed with last arg.**
-- @tparam function f Function to be guarded.
-- @param ... Arguments to pass to `f`
-- @return Result of `f`.
Biguard = (filter=->true) -> (transform, antitransform) -> (f) -> (...) ->
  return if filter ...
    argl = {transform ...}
    f unpack argl
  else
    argl = {antitransform ...}
    f unpack argl

--- Guards the result of a function.
-- @tparam function filter Filters whether the guard is applicable or not.
-- @tparam function transform If the guard is applicable, apply it and return.
-- @tparam function f Function to be guarded.
-- @param ... Arguments to pass to `f`
-- @return Result of `f` or nil.
Endguard = (filter=->true) -> (transform) -> (f) -> (...) ->
  return ... unless filter
  res = {f ...}
  transform unpack res

--- Guard that errors when it does not pass. **Curried function.**
-- @tparam function filter Filters whether the guard is applicable or not.
-- @tparam function transform If the guard is applicable, apply it and return.
-- @tparam function f Function to be guarded.
-- @param ... Arguments to pass to `f`
-- @return Whatever `f` returns.
-- @raise If the filter does not pass, it will error.
Errguard = (filter=->true) -> (transform) -> (f) -> (...) ->
  ok, why = filter ...
  error "did not pass guard! #{why}" unless ok
  argl = {transform ...}
  f unpack argl

--- Guard that errors when passed. **Curried function.**
-- @tparam function filter Filters whether the guard is applicable or not.
-- @tparam function transform If the guard is applicable, apply it and return.
-- @tparam function f Function to be guarded.
-- @param ... Arguments to pass to `f`
-- @return Whatever `f` returns.
-- @raise If the filter does not pass, it will error.
Antierrguard = (filter=->true) -> (transform) -> (f) -> (...) ->
  ok, why = filter ...
  error "did not pass guard! #{why}" if ok
  argl = {transform ...}
  f unpack argl

--- Guards the result of a function. This one raises an error if it does not pass.
-- @tparam function filter Filters whether the guard is applicable or not.
-- @tparam function transform If the guard is applicable, apply it and return.
-- @tparam function f Function to be guarded.
-- @param ... Arguments to pass to `f`
-- @return Result of `f` or nil.
-- @raise If the filter does not pass, it will error.
Enderrguard = (filter=->true) -> (transform) -> (f) -> (...) ->
  ok, why = filter ...
  error "did not pass guard! #{why}" unless ok
  res = {f ...}
  transform unpack res

--- Simple function composition.
-- @param ... All functions to compose
-- @treturn function Composed function.
compose = (...) ->
  argl = {...}
  (...) ->
    argk = {...}
    for f in *argl
      argk = f argk
    return argk

{ :Guard, :Antiguard, :Biguard, :Endguard, :Errguard, :Antierrguard, :Enderrguard, :compose }
