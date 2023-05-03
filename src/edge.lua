-- Override built-in type function
require "typeplus"

-- Edge for a graph

local Edge = {}

-- Creates a new edge
function Edge.new(node1, node2, weight)
	-- Type checking
	assert(type(node1) == "Node", "The data-type '" .. type(node1) .. "' is not of type Node")
	assert(type(node2) == "Node", "The data-type '" .. type(node2) .. "' is not of type Node")
	assert(type(weight) == "number" or type(weight) == "nil", "The data-type '" .. type(weight) .. "' is not of type number")


	return {
		-- Set data-type
		__type = "Edge",

		-- Define public properties
		nodes = {node1, node2},
		-- Weight has a default value of -1; indicating that it wasn't defined
		weight = weight or -1,

		-- Define public methods
		-- Checks if this edge contains a node
		contains = function (_, node)
			-- Type checking
			assert(type(node) == "Node", "The data-type '" .. type(node) .. "' is not of type Node")

			return node == node1 or node == node2
		end,

		-- Completely breaks the bonds between the two nodes
		snap = function (self)
			-- Remove references
			self.nodes = {}
			node1 = nil
			node2 = nil
		end


	}
end



return Edge