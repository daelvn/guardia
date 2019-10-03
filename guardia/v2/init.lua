local inspect_count = 0
local _filter
_filter = function(fl)
  return function(...)
    if fl(...) then
      return true, ...
    else
      return false, ...
    end
  end
end
local _true
_true = function(...)
  return true, ...
end
local _false
_false = function(...)
  return false, ...
end
local _transform
_transform = function(tr)
  return function(b, ...)
    if b then
      return true, tr(...)
    else
      return false, ...
    end
  end
end
local _negate
_negate = function(b, ...)
  return not b, ...
end
local _pass
_pass = function(b, ...)
  return ...
end
local _error
_error = function(msg)
  return function(b, ...)
    if b then
      return error(msg)
    else
      return false, ...
    end
  end
end
local _status
_status = function(b, ...)
  return b
end
local _inspect
_inspect = function(b, ...)
  inspect_count = inspect_count + 1
  print(inspect_count, b, ...)
  return b, ...
end
local _named
_named = function(msg)
  return function(b, ...)
    print(msg, b, ...)
    return b, ...
  end
end
local _default
_default = function(v)
  return function(...)
    return (_transform(function()
      return v
    end))((_filter(function(x)
      return "nil" == type(x)
    end))(...))
  end
end
local _finalize = _pass
local _fn = _finalize
local _ps = _pass
local _fl = _filter
local _tr = _transform
local _ng = _negate
local _er = _error
local _st = _status
local _in = _inspect
local _ci = _named
local _df = _default
local _t = _true
local _f = _false
local _e1 = _error("guardia $ chain was stopped")
local Guard
Guard = function(fl)
  return function(tr)
    return function(f)
      return function(...)
        return f(_fn((_tr(tr))((_fl(fl))(...))))
      end
    end
  end
end
local Antiguard
Antiguard = function(fl)
  return function(tr)
    return function(f)
      return function(...)
        return f(_fn((_tr(tr))(_ng((_fl(fl))(...)))))
      end
    end
  end
end
local Biguard
Biguard = function(fl)
  return function(tr, ar)
    return function(f)
      return function(...)
        return f(_fn((_tr(ar))(_ng((_fl(fl))(_ps((_tr(tr))((_fl(fl))(...))))))))
      end
    end
  end
end
local Endguard
Endguard = function(fl)
  return function(tr)
    return function(f)
      return function(...)
        return _fn((_tr(tr))((_fl(fl))(f(...))))
      end
    end
  end
end
local Errguard
Errguard = function(fl)
  return function(tr)
    return function(f)
      return function(...)
        return f(_fn(_e1((_fl(fl))(f(...)))))
      end
    end
  end
end
local Enderrguard
Enderrguard = function(fl)
  return function(tr)
    return function(f)
      return function(...)
        return _fn(_e1(f(...)))
      end
    end
  end
end
local Antierrguard
Antierrguard = function(fl)
  return function(tr)
    return function(f)
      return function(...)
        return f(_fm(_e1(_ng((_fl(fl))(f(...))))))
      end
    end
  end
end
return {
  _filter = _filter,
  _fl = _fl,
  _transform = _transform,
  _tr = _tr,
  _negate = _negate,
  _ng = _ng,
  _pass = _pass,
  _ps = _ps,
  _error = _error,
  _er = _er,
  _e1 = _e1,
  _status = _status,
  _st = _st,
  _finalize = _finalize,
  _fn = _fn,
  _inspect = _inspect,
  _in = _in,
  _named = _named,
  _ci = _ci,
  _default = _default,
  _df = _df,
  _true = _true,
  _t = _t,
  _false = _false,
  _f = _f,
  Guard = Guard,
  Antiguard = Antiguard,
  Biguard = Biguard,
  Endguard = Endguard,
  Errguard = Errguard,
  Enderrguard = Enderrguard,
  Antierrguard = Antierrguard
}
