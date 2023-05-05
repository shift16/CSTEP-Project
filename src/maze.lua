-- Import modules
local enforce_type = require "enforce_type"

-- Classes
local Graph = require "graph"

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

-- Creates a maze
function Maze.new(size_x, size_y)
	-- Type checking
	enforce_type("number", size_x, size_y)


	local maze_graph = Graph.new()

	local maze = {
		-- Deletes the created maze and reconstructs it
		reconstruct = function (self)
			-- Type checking
			enforce_type("Maze", self)


		end
	}


	return setmetatable(maze, MazeMT)
end

return Maze