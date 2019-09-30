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
