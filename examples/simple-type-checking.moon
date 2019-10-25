--> # Simple type checking
--# source
--> Simple type checking using Guàrdia.
guardia        = require "guardia"
guardia.guards = require "guardia.guards"

-- Identity function
id = (x) -> x

import _fn, _or1, _er, _ng from guardia

--- Check that we are taking in a string.
-- This does basically nothing, since we are not acting if it's a string.
-- Read as "If 5 is a string, pass on to id"
import _string, _not_string from guardia.guards
print type id _fn _string 5 -- number

--- If we're not taking a string, turn it into one
-- Read as "If 5 is not a string, transform into string and pass on to id"
import _tostring from guardia.guards
print type id _fn _tostring _not_string 5 -- string

--- Accept several types (such as both string and number).
-- Again, this does absolutely nothing since there is no transformer.
-- Read as "If 5 is a string or a number, pass on to id"
import _number from guardia.guards
print type id _fn (_or1 _string, _number) 5 -- number

--- Error throwing.
-- Create an error for a specific case, which will be thrown if needed.
-- Read as "If 5 is not a string or a number, error with 'myerror', otherwise pass on to id"
_e_myerror = _er "myerror: not a string or number"
print type id _fn _e_myerror _ng (_or1 _string, _number) 5      -- number
--print type id _fn _e_myerror _ng (_or1 _string, _number) true -- myerror: not a string or number

--- Chaining type transformations
-- Transformations are skipped if the filter does not pass, and we can chain them
-- using `_ps`. `_ps` and `_fn` are the same function.
import _boolean from guardia.guards
_ps = _fn
print type id _fn _tostring _boolean _ps _tostring _number {}   -- table
print type id _fn _tostring _boolean _ps _tostring _number 5    -- string
print type id _fn _tostring _boolean _ps _tostring _number true -- string
