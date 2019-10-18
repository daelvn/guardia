--> # guardia.init
--> Guards for Lua. Based upon [guard.lua](https://github.com/Yonaba/guard.lua).
--> This version is rather thought for curried functions and use with MoonScript.
inspect_count = 0

--> ## Sources
--> Sources are functions that take a set of values and start a guard chain. They're always
--> of the kind `(...) -> boolean, ...`.

--> ### _filter
--# _fl
--: _filter (function) -> (...) -> boolean, ...
--> Alias → `_fl`<br>
--> Filtering function. If the filter passes, the first returned value is `true`, `false` otherwise.
_filter = (fl) -> (...) -> if fl ... then true, ... else false, ...

--> ### _true
--# _t
--: _true (...) -> true, ...
--> Alias → `_t`<br>
--> Starts a chain, always returning `true`.
_true = (...) -> true, ...

--> ### _false
--# _f
--: _false (...) -> false, ...
--> Alias → `_f`<br>
--> Starts a chain, always returning `false`.
_false = (...) -> false, ...

--> ### _default
--# _df
--: _default (a) -> (...) -> false, ...
--> Alias → `_df`<br>
--> Makes the value of the chain `a` only if `...` is `nil`.
_default = (v) -> (...) -> return (_transform ->v) (_filter (x)->"nil"==type x) ...

--> ## Transformers
--> Transformers are functions which continue a chain, also modifying the arguments that go along
--> with the boolean. They're always of the kind `(boolean, ...) -> boolean, ...`.

--> ### _transform
--# _tr
--: _transform (function) -> (boolean, ...) -> boolean, ...
--> Alias → `_tr`<br>
--> Transforms the values being passed through a function, only if the boolean passed is `true`.
_transform = (tr) -> (b, ...) -> if b then true, tr ... else false, ...

--> ### _negate
--# _ng
--: _negate (boolean, ...) -> boolean, ...
--> Alias → `_ng`<br>
--> Negates the status from last operation.
_negate = (b, ...) -> not b, ...

--> ### _error
--# _er
--: _error (msg:string) -> (boolean, ...) -> false, ...
--> Alias → `_er`<br>
--> Raises → Error message passed to the function (if boolean is `false`).<br>
--> Errors with `msg` if the status is `true`.
_error = (msg) -> (b, ...) -> if b then error msg else false, ...

--> ### _e1
--# _e1
--: _e1 (boolean, ...) -> false, ...
--> Raises → "guardia $ chain was stopped"<br>
--> Predefined error for [_error](#_error).
_e1 = _error "guardia $ chain was stopped"

--> ### _inspect
--# _in
--: _inspect (boolean, ...) -> boolean, ...
--> Alias → `_in`<br>
--> Prints an inspect count number and every value on the chain, including the boolean.
_inspect = (b, ...) ->
  inspect_count += 1
  print inspect_count, b, ...
  return b, ...

--> ### _named
--# _ci
--: _named (msg:string) -> (boolean, ...) -> boolean, ...
--> Alias → `_ci`<br>
--> Complex inspect. Instead of the inspect count number, prints the message along with every value on the
--> chain and the status.
_named = (msg) -> (b, ...) ->
  print msg, b, ...
  return b, ...

--> ## Finalizers
--> Finalizers are functions that end a guard chain, returning only part of the values. Their form
--> can either be `(boolean, ...) -> boolean` or `(boolean, ...) -> ...`.

--> ### _pass
--# _ps
--: _pass (boolean, ...) -> ...
--> Alias → `_ps`, `_fn`<br>
--> Ignores the boolean and returns the varargs.
_pass = (b, ...) -> ...

--> ### _status
--# _st
--: _status (boolean, ...) -> boolean
--> Alias → `_st`<br>
--> Returns the status from the chain and nothing else.
_status = (b, ...) -> b


_finalize = _pass
_fn       = _finalize
_ps       = _pass
_fl       = _filter
_tr       = _transform
_ng       = _negate
_er       = _error
_st       = _status
_in       = _inspect
_ci       = _named
_df       = _default
_t        = _true
_f        = _false


--> ## v1 Guards
--> These guards are v1 replicas made using the new guard functions. They are the closest to
--> the original `guard.lua`. Most of them take the form `(function) -> (function) -> (function) -> (...) -> ...`.
--- guard.lua-style Guard. **Curried function.**

--> ### Guard
--# Guard
--: Guard (fl:function) -> (tr:function) -> (f:function) -> (...) -> ...
--> Uses a filter and transformer function on a set of values passed to `f`.
Guard        = (fl) -> (tr)     -> (f) -> (...) -> f _fn (_tr tr) (_fl fl) ...

--> ### Antiguard
--# Antiguard
--: Antiguard (fl:function) -> (tr:function) -> (f:function) -> (...) -> ...
--> Equivalent to [Guard](#Guard), but negates the results of `fl`.
Antiguard    = (fl) -> (tr)     -> (f) -> (...) -> f _fn (_tr tr) _ng (_fl fl) ...

--> ### Biguard
--# Biguard
--: Biguard (fl:function) -> (tr:function, ar:function) -> (f:function) -> (...) -> ...
--> Essentially a mix of [Guard](#Guard) and [Antiguard](#Antiguard), so the transformer `tr` runs
--> when the filter passes, `ar` otherwise.
Biguard      = (fl) -> (tr, ar) -> (f) -> (...) -> f _fn (_tr ar) _ng (_fl fl) _ps (_tr tr) (_fl fl) ...

--> ### Endguard
--# Endguard
--: Endguard (fl:function) -> (tr:function) -> (f:function) -> (...) -> ...
--> A guard for the result values of the function `f` called with `...`.
Endguard     = (fl) -> (tr)     -> (f) -> (...) -> _fn (_tr tr) (_fl fl) f ...

--> ### Errguard
--# Endguard
--> [Guard](#Guard) but errors if the filter does not pass.
Errguard     = (fl) -> (tr)     -> (f) -> (...) -> f _fn _e1 (_fl fl) f ...

--> ### Enderrguard
--# Enderrguard
--> [Endguard](#Endguard) but errors if the filter does not pass.
Enderrguard  = (fl) -> (tr)     -> (f) -> (...) -> _fn _e1 f ...

--> ### Antierrguard
--# Antierrguard
--> [Antiguard](#Antiguard) but errors if the filter does not pass.
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
