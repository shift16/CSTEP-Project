-- Import modules
local enforce_type = require "enforce_type"

-- Define the class constructor
local Edge = {}

-- Define the meta-table
local EdgeMT = {
	-- Defines the type of object
	__index = function (self, index)
		-- The __type property is always protected and therefore not modifiable
		if (index == "__type") then
			return "Edge"
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

function Edge.new(node1, node2, edge_id, weight)
	-- Type checking
	enforce_type("Node", node1, node2)
	enforce_type("number", weight)
	enforce_type("string", edge_id)

	return setmetatable({
		-- Define public properties
		weight = weight,
		id = edge_id,
		starting_node = node1,
		ending_node = node2,

		-- Define public methods
		-- Checks if a node is a part of the edge
		contains = function (_, node)
			-- Type checking
			enforce_type("Node", node)

			return node1 == node or node2 == node
		end
	}, EdgeMT)
end

return Edge