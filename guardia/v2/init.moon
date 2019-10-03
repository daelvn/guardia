--- Guards for Lua. Based upon [guard.lua](https://github.com/Yonaba/guard.lua).
-- This version is rather thought for curried functions and use with MoonScript.
-- @module guardia.v2.init`
-- @author daelvn
inspect_count = 0

--- Filtering function. **Curried function.** Alias `_fl`.
-- @tparam function fl Filter.
-- @treturn function Function that returns whether the filter matched or not, and the arguments passed to it.
_filter = (fl) -> (...) -> if fl ... then true, ... else false, ...
--- Starts a chain, forcing transformation. **Curried function.** Alias `_t`.
-- @param ... Parameters to start the chain.
-- @treturn boolean `true`
-- @return ...
_true = (...) -> true, ...
--- Starts a chain, not forcing transformation. **Curried function.** Alias `_f`.
-- @param ... Parameters to start the chain.
-- @treturn boolean `false`
-- @return ...
_false = (...) -> false, ...
--- Transforming function. **Curried function.** Alias `_tr`.
-- @tparam function tr Transformer.
-- @treturn function Function that returns whether the arguments were transformed or not, and the arguments passed to it.
_transform = (tr) -> (b, ...) -> if b then true, tr ... else false, ...
--- Negating function. Alias `_ng`.
-- @tparam boolean b Status from last operation.
-- @param ... Arguments in the stream.
-- @treturn boolean Opposite status.
-- @return ... Same arguments in the stream.
_negate = (b, ...) -> not b, ...
--- Filtering function. *Alias `_ps`.*
-- @tparam boolean b Status from last operation.
-- @param ... Arguments in the stream.
-- @return ... Same arguments in the stream.
_pass = (b, ...) -> ...
--- Filtering function. **Curried function.** *Alias `_er`.*
-- @tparam string msg Error message.
-- @tparam boolean b Status from last operation.
-- @param ... **Passed along with last argument.** Arguments in the stream.
-- @raise Errors with `msg` is `b` is `true`.
_error = (msg) -> (b, ...) -> if b then error msg else false, ...
--- Filtering function. *Alias `_st`.*
-- @tparam boolean b Status from last operation.
-- @param ... Arguments in the stream.
-- @treturn boolean Status from last operation.
_status = (b, ...) -> b
--- Inspects the values being passed. *Alias `_in`.*
-- @tparam boolean b Status from last operation.
-- @param ... Arguments in the stream.
-- @treturn boolean Status from last operation.
-- @return ... Same arguments in the stream.
_inspect = (b, ...) ->
  inspect_count += 1
  print inspect_count, b, ...
  return b, ...
--- Complex inspect. Takes an extra message. **Curried function.** **Alias `_ci`.*
-- @tparam string msg Error message.
-- @tparam boolean b Status from last operation.
-- @param ... **Passed along with last argument.** Arguments in the stream.
-- @treturn boolean Status from last operation.
-- @return ... Same arguments in the stream.
_named = (msg) -> (b, ...) ->
  print msg, b, ...
  return b, ...
--- Outputs `false` and the default value if `nil` is passed. **Curried function.** Alias `_df`.
-- @param v Value to make default.
-- @treturn function Function that acts as a transformer for the value. `b` is always `false`.
_default = (v) -> (...) -> return (_transform ->v) (_filter (x)->"nil"==type x) ...

--- Alias to `_pass`
-- @function _finalize
_finalize = _pass

_fn = _finalize
_ps = _pass
_fl = _filter
_tr = _transform
_ng = _negate
_er = _error
_st = _status
_in = _inspect
_ci = _named
_df = _default
_t  = _true
_f  = _false
--- `_error` with a default error message.
-- @function _e1
-- @tparam boolean b Status from last operation.
-- @param ... Arguments in the stream.
_e1 = _error "guardia $ chain was stopped"

--- guard.lua-style Guard. **Curried function.**
-- @tparam function filter Filters whether the guard is applicable or not.
-- @tparam function transform If the guard is applicable, apply it and return.
-- @tparam function f Function to be guarded.
-- @param ... Arguments to pass to `f`
-- @return Result of `f` or nil, if guarded.
Guard        = (fl) -> (tr)     -> (f) -> (...) -> f _fn (_tr tr) (_fl fl) ...
--- Guard that transforms when it does not pass the filter. **Curried function.**
-- @tparam function filter Filters whether the guard is applicable or not.
-- @tparam function transform If the guard is applicable, apply it and return.
-- @tparam function f Function to be guarded.
-- @param ... Arguments to pass to `f`
-- @return Result of `f` or nil, if not guarded.
Antiguard    = (fl) -> (tr)     -> (f) -> (...) -> f _fn (_tr tr) _ng (_fl fl) ...
--- Guard with two transformers, one if the filte passes, one if it doesn't. **Curried function.**
-- @tparam function filter Filters whether the guard is applicable or not.
-- @tparam function transform If the guard is applicable, apply it and return.
-- @tparam function antitransform If the guard is not applicable, apply this one and return. **Passed with last arg.**
-- @tparam function f Function to be guarded.
-- @param ... Arguments to pass to `f`
-- @return Result of `f`.
Biguard      = (fl) -> (tr, ar) -> (f) -> (...) -> f _fn (_tr ar) _ng (_fl fl) _ps (_tr tr) (_fl fl) ...
--- Guards the result of a function.
-- @tparam function filter Filters whether the guard is applicable or not.
-- @tparam function transform If the guard is applicable, apply it and return.
-- @tparam function f Function to be guarded.
-- @param ... Arguments to pass to `f`
-- @return Result of `f` or nil.
Endguard     = (fl) -> (tr)     -> (f) -> (...) -> _fn (_tr tr) (_fl fl) f ...
--- Guard that errors when it does not pass. **Curried function.**
-- @tparam function filter Filters whether the guard is applicable or not.
-- @tparam function transform If the guard is applicable, apply it and return.
-- @tparam function f Function to be guarded.
-- @param ... Arguments to pass to `f`
-- @return Whatever `f` returns.
-- @raise If the filter does not pass, it will error.
Errguard     = (fl) -> (tr)     -> (f) -> (...) -> f _fn _e1 (_fl fl) f ...
--- Guards the result of a function. This one raises an error if it does not pass.
-- @tparam function filter Filters whether the guard is applicable or not.
-- @tparam function transform If the guard is applicable, apply it and return.
-- @tparam function f Function to be guarded.
-- @param ... Arguments to pass to `f`
-- @return Result of `f` or nil.
-- @raise If the filter does not pass, it will error.
Enderrguard  = (fl) -> (tr)     -> (f) -> (...) -> _fn _e1 f ...
--- Guard that errors when passed. **Curried function.**
-- @tparam function filter Filters whether the guard is applicable or not.
-- @tparam function transform If the guard is applicable, apply it and return.
-- @tparam function f Function to be guarded.
-- @param ... Arguments to pass to `f`
-- @return Whatever `f` returns.
-- @raise If the filter does not pass, it will error.
Antierrguard = (fl) -> (tr)     -> (f) -> (...) -> f _fm _e1 _ng (_fl fl) f ...

{
  :_filter,    :_fl
  :_transform, :_tr
  :_negate,    :_ng
  :_pass,      :_ps
  :_error,     :_er, :_e1
  :_status,    :_st
  :_finalize,  :_fn
  :_inspect,   :_in
  :_named,     :_ci
  :_default,   :_df
  :_true,      :_t
  :_false,     :_f
  --
  :Guard
  :Antiguard
  :Biguard
  :Endguard
  :Errguard
  :Enderrguard
  :Antierrguard
}
