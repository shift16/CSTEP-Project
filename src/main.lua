-- Import modules
local Graph = require "graph"

-- Override built-in type function
require "typeplus"

-- Loads the maze
function love.load( ... )
	local graph1 = Graph.new()

	local node1 = graph1:create_node("A")
	local node2 = graph1:create_node("B")
	local node3 = graph1:create_node("C")

	local edge_between_node1_and_2 = node1:connect(node2)
	node1:disconnect(node2)

	print(edge_between_node1_and_2:contains(node1), edge_between_node1_and_2:contains(node2), edge_between_node1_and_2:contains(node3))
end

function love.update( ... )
	-- body
end

function love.draw( ... )
	-- body
end