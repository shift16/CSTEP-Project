-- Overrides the built-in type function
-- Save reference to old type function
local old_type = type

-- Override the type function
type = function (obj)
	local obj_type = old_type(obj)

	if (obj_type == "table") then
		return obj.__type or "table"
	else
		return obj_type
	end
end