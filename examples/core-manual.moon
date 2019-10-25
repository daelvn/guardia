g = require "guardia"

-- Getting started
print g._finalize g._true  5, 6
print g._finalize g._false 5, 6

print g._fn g._t 5, 6
print g._fn g._f 5, 6

print g._fn g._in g._t 5, 6
print g._fn (g._ci "hewwo") g._t 5, 6

-- Getting spicy
is5 = (...) ->
  args, status = {...}, true
  for arg in *args
    status = false if arg != 5
  return status

print g._st (g._fl is5) 5, 5
print g._st (g._fl is5) 5, 6
print g._st g._ng (g._fl is5) 5, 5

-- Getting useful
to3 = (...) ->
  args = {...}
  return table.unpack for i=1, #args do 3
  -- for those unfamiliar with MoonScript syntax, this essentially creates a table of length #args that only
  -- contains 3s, and then unpacks it and returns all the 3s individually.

print g._fn (g._tr to3) g._t 5, true, "a"

print g._fn (g._tr to3) (g._fl is5) 5, true, "a"
print g._fn (g._tr to3) (g._fl is5) 5, 5, 5

-- Getting nasty
_number = g._fl (x) -> (type x) == "number" -- Mind the use of _fl!

_e_notnumber = g._er "That's not a number!"

print g._fn _e_notnumber g._ng _number 5

-- Getting a burrito
_myFunction = => (...) -> @ g._fn _e_notnumber g._ng _number ...
myFunction = _myFunction (x) -> x

-- Getting logical
_is4or5 = g._or1 (g._fl is4), (g._fl is5)

-- Getting safe
print g._fn (g._df 5) nil
