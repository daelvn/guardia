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
