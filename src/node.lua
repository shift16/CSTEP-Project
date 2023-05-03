-- Import modules
local Edge = require "edge"

-- Override built-in type function
require "typeplus"


-- Node for a graph
local Node = {}

-- Private helper function
-- Returns if two nodes are linked and the edge that links them
local function is_linked(edge_array, node)
	-- Type checking
	assert(type(edge_array) == "table", "The data-type '" .. type(edge_array) .. "' is not of type table")
	assert(type(node) == "Node", "The data-type '" .. type(node) .. "' is not of type Node")

	for _, edge in ipairs(edge_array) do
		-- Type checking (Pending removal)
		assert(type(edge) == "Edge", "The data-type '" .. type(edge) .. "' is not of type Edge")
		
		if edge:contains(node) then
			return true, edge
		end
	end

	return false, nil
end

-- Creates a new node
function Node.new(id)
	-- Type checking
	assert(type(id) == "string", "The data-type '" .. type(id) .. "' is not of type string")

	-- Define private properties
	local edges = {}

	return {
		-- Set data-type
		__type = "Node",

		-- Define public properties
		id = id or nil,
		-- Define public methods
		-- Connects the two nodes and returns the created edge
		connect = function (self, node)
			-- Type checking
			assert(type(node) == "Node", "The data-type '" .. type(node) .. "' is not of type Node")

			-- Runtime error checking
			-- Make sure this node is not already linked
			if is_linked(edges, node) then
				error("Node " .. tostring(self) .. " is already linked to " .. tostring(node))
			end

			-- Creates an edge with no weight set to it
			local new_edge = Edge.new(self, node, nil)

			table.insert(edges, new_edge)

			return new_edge
		end,

		-- Disconnects the two nodes and returns the deleted edge
		disconnect = function (self, node)
			-- Type checking
			assert(type(node) == "Node", "The data-type '" .. type(node) .. "' is not of type Node")

			local connection_status, connecting_edge = is_linked(edges, node)
			
			-- Runtime error checking
			-- Make sure that these two nodes are actually connected
			if (connection_status == false) then
				error("The following node " .. tostring(self) .. " is already linked to " .. tostring(node))
			end

			-- The result from is_linked won't be nil if connection_status is true
			---@diagnostic disable-next-line: need-check-nil
			connecting_edge:snap()

			-- Remove the edge
			for index, edge in ipairs(edges) do
				if edge == connecting_edge then
					table.remove(edge, index)
					break
				end
			end

			return connecting_edge
		end

	}
end

return Node