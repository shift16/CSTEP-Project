-- Returns a custom type function
return function (obj)
	local obj_type = type(obj)

	if (obj_type == "table") then
		-- Classes will have the property __type set to a custom value
		return obj.__type or "table"
	else
		return obj_type
	end
end