-- Import modules
local enforce_type = require "enforce_type"

-- Define the class constructor
local Queue = {}

-- Define the meta-table
local QueueMT = {
	-- Defines the type of object
	__index = function (self, index)
		-- The __type property is always protected and therefore not modifiable
		if (index == "__type") then
			return "Queue"
		else
			error("The property " .. index .. " does not exist in type " .. self.__type)
		end
	end,

	-- Prevents the modification of undefined and protected properties
	__newindex = function (self, index, _)
		if (self[index] ~= nil) then
			error("The property " .. index .. " is not modifiable in type " .. self.__type)
		else
			error("The property " .. index .. " does not exist in type " .. self.__type)
		end
	end,

	-- Locks the meta-table
	__metatable = not nil
}

function Queue.new()
	-- Define private properties
	local arr = {}

	return setmetatable({
		-- Define public methods
		-- Adds a element to the queue
		enqueue = function (_, obj)
			table.insert(arr, obj)
		end,

		-- Removes an element from the queue
		dequeue = function ()
			-- Runtime error checking
			-- Make sure the array has more than one element in it
			if #arr < 1 then
				error("The queue is empty")
			end

			return table.remove(arr, 1)
		end,

		-- Checks if the queue is empty
		is_empty = function ()
			return not (#arr > 0)
		end
	}, QueueMT)
end

return Queue