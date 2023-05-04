-- Import modules
local enforce_type = require "enforce_type"
local type = require "typeplus"

-- Classes
local Graph = require "graph"
local Node = require "node"

-- Loads the maze
function love.load( ... )
	local graph1 = Graph.new()

	local node1 = graph1:create_node("A")
	local node2 = graph1:create_node("B")
	local node3 = graph1:create_node("C")

	local edge1, edge2 = graph1:create_bi_directional_link("A", "B", 1)
	local edge3 = graph1:create_one_directional_link("A", "C", 1)

	print(edge1, edge2, edge3)
	local connected_to_1 = graph1:get_linked_nodes(node1)

	for index, node in ipairs(connected_to_1) do
		print(index, node.id)
	end
end

function love.update( ... )
	-- body
end

function love.draw( ... )
	-- body
end