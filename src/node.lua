-- Import modules
local enforce_type = require "enforce_type"

-- Define the class constructor
local Node = {}

-- Define the meta-table
local NodeMT = {
	-- Defines the type of object
	__index = function (self, index)
		-- The __type property is always protected and therefore not modifiable
		if (index == "__type") then
			return "Node"
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

function Node.new(node_id)
	-- Type checking
	enforce_type("string", node_id)

	return setmetatable({
		-- Define public properties
		edges = {},
		id = node_id,

		-- Define public methods
		is_linked = function (self, node)
			-- Type checking
			enforce_type("Node", self, node)

			for _, edge in ipairs(self.edges) do
				if (edge:contains(node)) then
					return true
				end
			end

			return false
		end
	}, NodeMT)
end

return Node