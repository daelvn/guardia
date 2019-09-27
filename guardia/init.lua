local unpack = unpack or table.unpack
local Guard
Guard = function(filter)
  if filter == nil then
    filter = function()
      return true
    end
  end
  return function(transform)
    return function(f)
      return function(...)
        if not (filter(...)) then
          return ...
        end
        local argl = {
          transform(...)
        }
        return f(unpack(argl))
      end
    end
  end
end
local Antiguard
Antiguard = function(filter)
  if filter == nil then
    filter = function()
      return false
    end
  end
  return function(transform)
    return function(f)
      return function(...)
        if filter(...) then
          return ...
        end
        local argl = {
          transform(...)
        }
        return f(unpack(argl))
      end
    end
  end
end
local Biguard
Biguard = function(filter)
  if filter == nil then
    filter = function()
      return true
    end
  end
  return function(transform, antitransform)
    return function(f)
      return function(...)
        if filter(...) then
          local argl = {
            transform(...)
          }
          return f(unpack(argl))
        else
          local argl = {
            antitransform(...)
          }
          return f(unpack(argl))
        end
      end
    end
  end
end
local Endguard
Endguard = function(filter)
  if filter == nil then
    filter = function()
      return true
    end
  end
  return function(transform)
    return function(f)
      return function(...)
        if not (filter) then
          return ...
        end
        local res = {
          f(...)
        }
        return transform(unpack(res))
      end
    end
  end
end
local Errguard
Errguard = function(filter)
  if filter == nil then
    filter = function()
      return true
    end
  end
  return function(transform)
    return function(f)
      return function(...)
        local ok, why = filter(...)
        if not (ok) then
          error("did not pass guard! " .. tostring(why))
        end
        local argl = {
          transform(...)
        }
        return f(unpack(argl))
      end
    end
  end
end
local Antierrguard
Antierrguard = function(filter)
  if filter == nil then
    filter = function()
      return true
    end
  end
  return function(transform)
    return function(f)
      return function(...)
        local ok, why = filter(...)
        if ok then
          error("did not pass guard! " .. tostring(why))
        end
        local argl = {
          transform(...)
        }
        return f(unpack(argl))
      end
    end
  end
end
local Enderrguard
Enderrguard = function(filter)
  if filter == nil then
    filter = function()
      return true
    end
  end
  return function(transform)
    return function(f)
      return function(...)
        local ok, why = filter(...)
        if not (ok) then
          error("did not pass guard! " .. tostring(why))
        end
        local res = {
          f(...)
        }
        return transform(unpack(res))
      end
    end
  end
end
local compose
compose = function(...)
  local argl = {
    ...
  }
  return function(...)
    local argk = {
      ...
    }
    for _index_0 = 1, #argl do
      local f = argl[_index_0]
      argk = f(argk)
    end
    return argk
  end
end
return {
  Guard = Guard,
  Antiguard = Antiguard,
  Biguard = Biguard,
  Endguard = Endguard,
  Errguard = Errguard,
  Antierrguard = Antierrguard,
  Enderrguard = Enderrguard,
  compose = compose
}
