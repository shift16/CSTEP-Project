-- Import modules
local Node = require "node"
local Edge = require "edge"

-- Override built-in type function
require "typeplus"

-- A graph
local Graph = {}

-- Allow graph to create bonds between nodes

function Graph.new()
	-- Define private properties
	local nodes = {}

	return {
		-- Set data-type
		__type = "Graph",

		-- Define public methods
		-- Creates a new node and returns it
		create_node = function (self, id)
			-- Type checking
			assert(type(id) == "string", "The data-type '" .. type(id) .. "' is not of type string")

			local new_node = Node.new(id)

			-- Store the new node using its hash code and the its id
			nodes[tostring(new_node) .. id] = new_node

			return new_node
		end
	}
end


return Graph