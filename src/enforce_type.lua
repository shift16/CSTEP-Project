-- Import modules
local type = require "typeplus"

-- Makes sure the selected object or objects is of a certain type
 return function (expected_type, ...)
	-- Type checking
	assert(type(expected_type) == "string", "Expected type string. Not type " .. type(expected_type))
	
	local args = {...}

	for i = 1, math.max(1, #args) do
		local obj = args[i]
		
		assert(type(obj) == expected_type, "Expected type " .. expected_type .. ". Not type " .. type(obj))
	end

end