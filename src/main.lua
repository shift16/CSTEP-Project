-- Import modules
local enforce_type = require "enforce_type"
local type = require "typeplus"

-- Classes
local Maze = require "maze"

-- Loads the maze
function love.load( ... )
	math.randomseed(12345)
	
	the_maze = Maze.new(30, 30)
	i = 0
	
	the_cells = the_maze:generate_cells()
	love.window.setMode(960, 960)
	love.window.setTitle("Maze Solver")
end

function love.update( ... )
	i = i + .01
end

function love.draw( ... )
	love.graphics.setBackgroundColor(1, 1, 1, 1)
	for _, cell in ipairs(the_cells) do
		cell:draw_using_node()
	end
end