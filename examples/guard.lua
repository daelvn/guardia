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
