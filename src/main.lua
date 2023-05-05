-- Import modules
local enforce_type = require "enforce_type"
local type = require "typeplus"

-- Classes
local Maze = require "maze"
local Graph = require "graph"
local PriorityQueue = require "priority_queue"

-- Loads the maze
function love.load( ... )
	-- the_maze = Maze.new(30, 30)
	local graph1 = Graph.new()

	graph1:create_node("A") 
	graph1:create_node("B") 
	graph1:create_node("C") 
	graph1:create_node("D") 
	graph1:create_node("E")
	graph1:create_node("G")
	graph1:create_node("S")

	graph1:create_bi_directional_link("S", "B", 7)
	graph1:create_bi_directional_link("S", "A", 2)
	graph1:create_bi_directional_link("S", "C", 8)
	graph1:create_bi_directional_link("A", "D", 9)
	graph1:create_bi_directional_link("C", "E", 1)
	graph1:create_bi_directional_link("E", "D", 5)
	graph1:create_bi_directional_link("E", "G", 3)
	graph1:create_bi_directional_link("D", "G", 7)
	graph1:create_bi_directional_link("D", "E", 5)
	graph1:create_bi_directional_link("E", "D", 5)


	local dijkstra_obj = graph1:create_dijkstra("S", "G")
	-- print(dijkstra_obj:is_complete())

	while not dijkstra_obj:is_complete() do
		for key, value in pairs(dijkstra_obj:capture_progress()) do
			print(key, value.dist)
		end
		print()
		dijkstra_obj:step()
	end

	local shortest_path = ""

	if dijkstra_obj:shortest_path() ~= nil then
		for _, node in ipairs(dijkstra_obj:shortest_path()) do
			shortest_path = shortest_path .. node.id
		end
	else
		print("No path available")
	end

	print(shortest_path)
	
end

function love.update( ... )
	-- body
end

function love.draw( ... )
	-- body
end