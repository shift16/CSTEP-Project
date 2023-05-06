-- Import modules
local enforce_type = require "enforce_type"

-- Classes
local Graph = require "graph"
local Cell = require "cell"

-- Define the class constructor
local Maze = {}

-- Define the meta-table
local MazeMT = {
	-- Defines the type of object
	__index = function (self, index)
		-- The __type property is always protected and therefore not modifiable
		if (index == "__type") then
			return "Maze"
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

-- Define private constants
local CELL_SIZE_X = 30
local CELL_SIZE_Y = 30
local CELL_COLOR = {1, 1, 1, 1}
local EDGE_COLOR = {0, 0, 0, 1}

-- Creates a maze
function Maze.new(size_x, size_y)
	-- Type checking
	enforce_type("number", size_x, size_y)

	-- Define private properties
	local maze_graph
	local new_maze

	new_maze = {
		-- Define public methods
		-- Deletes the created maze and reconstructs it
		reconstruct = function (_, new_size_x, new_size_y)
			-- Type checking
			enforce_type("number", new_size_x, new_size_y)
			
			-- Purge old graph and create new one
			maze_graph = Graph.new()

			-- Create a n by n grid of nodes
			for x = 1, new_size_x do
				for y = 1, new_size_y do
					maze_graph:create_node(tostring(x) .. " " .. tostring(y))
				end
			end
			
			-- Create the connections between each node
			for x = 1, new_size_x do
				for y = 1, new_size_y do
					local current_node = maze_graph:get_node(tostring(x) .. " " .. tostring(y))

					local left_node = maze_graph:get_node(tostring(x - 1) .. " " .. tostring(y))
					local right_node = maze_graph:get_node(tostring(x + 1) .. " " .. tostring(y))
					local top_node = maze_graph:get_node(tostring(x) .. " " .. tostring(y - 1))
					local bottom_node = maze_graph:get_node(tostring(x) .. " " .. tostring(y + 1))
					print(tostring(x) .. " " .. tostring(y + 1))

					local possible_nodes = {left_node, right_node, top_node, bottom_node}

					for _, node in ipairs(possible_nodes) do
						if node ~= nil then
							if not node:is_linked(current_node) then
								maze_graph:create_bi_directional_link(current_node.id, node.id, 1)
							end
						end
					end
				end
			end

			-- Randomly break connections between points
			for x = 1, size_x do
				for y = 1, size_y do
					local current_node = maze_graph:get_node(tostring(x) .. " " .. tostring(y))
					local current_chance = math.random()

					if current_chance > .7 then
						-- Delete some of its nodes!
						local possible_nodes = maze_graph:get_linked_nodes(current_node.id)
						local nodes_to_delete = math.random(1, #possible_nodes)

						local deleted_nodes = 0

						for _, node in pairs(possible_nodes) do
							if deleted_nodes == nodes_to_delete then
								-- Stop the loop
								break
							end

							if math.random() > .4 then
								maze_graph:purge_link(current_node.id, node.id)
							end

							deleted_nodes = deleted_nodes + 1	
						end

					end

				end
			end

			return new_maze
		end,

		-- Returns the graph
		get_graph = function ()
			return maze_graph
		end,

		-- Returns an array of cells from the graph
		generate_cells = function ()
			local cells = {}

			for x = 1, size_x do
				for y = 1, size_y do
					local x_str = tostring(x)
					local y_str = tostring(y)

					local node = maze_graph:get_node(x_str .. " " .. y_str)

					local new_cell = Cell.new(CELL_SIZE_X, CELL_SIZE_Y, maze_graph, node, CELL_COLOR, EDGE_COLOR)

					table.insert(cells, new_cell)
				end
			end

			return cells
		end

	}

	new_maze:reconstruct(size_x, size_y)

	return setmetatable(new_maze, MazeMT)
end

return Maze