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
