-- Import modules
local enforce_type = require "enforce_type"

-- Classes
local Edge = require "edge"
local Node = require "node"
local Dijkstra = require "dijkstra"

-- Define the class constructor
local Graph = {}

-- Define the meta-table
local GraphMT = {
	-- Defines the type of object
	__index = function (self, index)
		-- The __type property is always protected and therefore not modifiable
		if (index == "__type") then
			return "Graph"
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

-- Creates a graph
function Graph.new()
	-- Define private properties
	local edges = {}
	local nodes = {}

	return setmetatable({
		-- Define public methods
		-- Creates a new node and returns the id
		create_node = function (_, node_id)
			-- Type checking
			enforce_type("string", node_id)

			-- Runtime error checking
			-- Make sure the node ID doesn't already exist
			if nodes[node_id] ~= nil then
				error("The node " .. node_id .. " already exists")
			end

			local new_node = Node.new(node_id)

			nodes[node_id] = new_node

			return node_id
		end,

		-- Creates a one-directional link between two nodes (node1 -> node2) and returns the ID for the new edge
		create_one_directional_link = function (_, node1_id, node2_id, weight)
			-- Type checking
			enforce_type("string", node1_id, node2_id)
			enforce_type("number", weight)

			-- Runtime error checking
			-- Make sure these nodes actually exist
			if nodes[node1_id] == nil then
				error("The following node " .. node1_id .. " does not exist in the graph")
			end

			if nodes[node2_id] == nil then
				error("The following node " .. node2_id .. " does not exist in the graph")
			end

			local edge_id = node1_id .. node2_id

			-- Make sure the edge doesn't already exist
			if edges[edge_id] ~= nil then
				error("The following connection going from node " .. node1_id .. " to " .. node2_id .. " already exists")	
			end

			local node1 = nodes[node1_id]
			local node2 = nodes[node2_id]

			local new_edge = Edge.new(node1, node2, edge_id, weight)

			-- Add the edge to the dictionary
			edges[edge_id] = new_edge
			
			-- Add the edge to the node's edges array
			table.insert(node1.edges, new_edge)

			return edge_id
		end,

		-- Creates a bi-directional link between two nodes (node1 <-> node2) and returns two IDs for the created edges
		create_bi_directional_link = function (self, node1_id, node2_id, weight)
			-- Type checking
			enforce_type("Graph", self)
			enforce_type("string", node1_id, node2_id)
			enforce_type("number", weight)

			-- A bi-directional link is just two one-directional links
			local edge1_id = self:create_one_directional_link(node1_id, node2_id, weight)
			local edge2_id = self:create_one_directional_link(node2_id, node1_id, weight)

			return edge1_id, edge2_id
		end,

		-- Returns the node from the given ID or nil if it doesn't exist
		get_node = function (_, node_id)
			-- Type checking
			enforce_type("string", node_id)

			return nodes[node_id]
		end,

		-- Returns the edge from the given ID or nil if it doesn't exist
		get_edge = function (_, edge_id)
			-- Type checking
			enforce_type("string", edge_id)

			return edges[edge_id]
		end,

		-- Gets and returns the nodes connected to the provided node_id
		get_linked_nodes = function (_, node_id)
			-- Type checking
			enforce_type("string", node_id)

			-- Runtime error checking
			-- Make sure the node actually exists
			if nodes[node_id] == nil then
				error("The following node " .. node_id .. " does not exist")	
			end

			local connected_nodes = {}

			for _, edge in ipairs(nodes[node_id].edges) do
				table.insert(connected_nodes, edge.ending_node)
			end

			return connected_nodes
		end,

		-- Returns an object that performs Dijkstra's algorithm per call to the step function
		create_dijkstra = function (self, node1_id, node2_id)
			-- Type checking
			enforce_type("Graph", self)
			enforce_type("string", node1_id, node2_id)

			-- Runtime error checking
			-- Make sure the nodes exist
			if nodes[node1_id] == nil then
				error("The following node " .. node1_id .. " does not exist in the graph")
			end

			if nodes[node2_id] == nil then
				error("The following node " .. node2_id .. " does not exist in the graph")
			end

			local starting_node = nodes[node1_id]
			local ending_node = nodes[node2_id]

			return Dijkstra.new(self, starting_node, ending_node)
		end,

		-- Destroys the edge connecting node 1 to node 2
		destroy_link_with = function (_, node1_id, node2_id)
			-- Type checking
			enforce_type("string", node1_id, node2_id)

			local node = nodes[node1_id]
			local linked_node = nodes[node2_id]

			-- Runtime error checking
			-- Make sure these nodes actually exist
			if nodes[node1_id] == nil then
				error("The following node " .. node1_id .. " does not exist in the graph")
			end

			if nodes[node2_id] == nil then
				error("The following node " .. node2_id .. " does not exist in the graph")
			end

			-- Make sure the other node is actually linked to it
			if not node:is_linked(linked_node) then
				error("The following node " .. linked_node.id .. " is not linked to " .. node.id)
			end

			for index, edge in ipairs(node.edges) do
				if edge:contains(linked_node) then
					-- Destroy the edge
					local edge_id = edge:destroy()
					-- Remove it from the dictionary
					edges[edge_id] = nil
					-- Remove it from the nodes array
					table.remove(node.edges, index)
					break
				end
			end
		end,

		purge_link = function (self, node1_id, node2_id)
			-- Type checking
			enforce_type("Graph", self)
			enforce_type("string", node1_id, node2_id)

			self:destroy_link_with(node1_id, node2_id)
			self:destroy_link_with(node2_id, node1_id)
		end
	}, GraphMT)
end

return Graph