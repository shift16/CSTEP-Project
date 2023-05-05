-- Import modules
local enforce_type = require "enforce_type"

-- Classes
local Queue = require "queue"

-- Define the class constructor
local PriorityQueue = {}

-- Define the meta-table
local PriorityQueueMT = {
	-- Defines the type of object
	__index = function (self, index)
		-- The __type property is always protected and therefore not modifiable
		if (index == "__type") then
			return "PriorityQueue"
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

-- Creates a priority queue
function PriorityQueue.new()
	-- Define private properties
	local arr = {}

	return setmetatable({
		-- Define public methods
		-- Adds an element to the priority queue
		enqueue = function (_, obj, priority)
			-- Type checking
			enforce_type("number", priority)

			-- Runtime error checking
			-- If the priority is 0 (which is a valid priority then add 1 to it
			if priority == 0 then
				priority = priority + 1
			end

			-- Make sure the priority is not below 0
			if priority < 0 then
				error("The priority " .. priority .. " is not valid as it is less than 0")
			end

			if priority > #arr then
				while priority > #arr do
					table.insert(arr, Queue.new())
				end
			end

			arr[priority]:enqueue(obj)
		end,

		-- Remove an element from the priority queue
		dequeue = function ()
			for _, queue in ipairs(arr) do
				if not queue:is_empty() then
					return queue:dequeue()
				end
			end

			-- Runtime error checking
			-- If the above code does not return, then the priority queue is empty
			error("The priority queue is empty")
		end,

		-- Checks if the priority queue is empty
		is_empty = function ()
			for _, queue in ipairs(arr) do
				if not queue:is_empty() then
					return false
				end
			end

			return true
		end
	}, PriorityQueueMT)
end

return PriorityQueue