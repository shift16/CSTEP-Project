-- Import modules
local enforce_type = require "enforce_type"

-- Classes
local PriorityQueue = require "priority_queue"

-- Define the class constructor
local Dijkstra = {}

-- Define the meta-table
local DijkstraMT = {
	-- Defines the type of object
	__index = function (self, index)
		-- The __type property is always protected and therefore not modifiable
		if (index == "__type") then
			return "Dijkstra's Algorithm"
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

-- Private helper function
-- Checks if the following node was visited
local function visited(visited_dictionary, node)
	-- Type checking
	enforce_type("table", visited_dictionary)
	enforce_type("Node", node)

	return visited_dictionary[node.id] ~= nil
end

-- Returns the current distance away from the starting node
local function get_distance(visited_dictionary, node)
	-- Type checking
	enforce_type("table", visited_dictionary)
	enforce_type("Node", node)

	local key = node.id
	
	-- Runtime error checking
	-- Make sure the key exists in the dictionary
	if visited_dictionary[key] == nil then
		error("The following node " .. key .. " has not been visited yet")
	end

	return visited_dictionary[key].dist
end

-- Returns the parent of the visited node or nil if it doesn't exist
local function get_parent(visited_dictionary, node)
	-- Type checking
	enforce_type("table", visited_dictionary)
	enforce_type("Node", node)

	local key = node.id
	
	-- Runtime error checking
	-- Make sure the key exists in the dictionary
	if visited_dictionary[key] == nil then
		error("The following node " .. key .. " has not been visited yet")
	end

	return visited_dictionary[key].parent_node
end

-- Creates an object that performs Dijkstra's algorithm per step
function Dijkstra.new(graph, starting_node, ending_node)
	-- Type checking
	enforce_type("Graph", graph)
	enforce_type("Node", starting_node, ending_node)

	-- Define private properties
	-- Dictionary of visited nodes
	local visited_nodes = {
		-- The starting node is automatically visited
		[starting_node.id] = {dist = 0, parent_node = nil}
	}
	
	-- Create the priority queue
	local priority_queue = PriorityQueue.new()
	priority_queue:enqueue(starting_node, 0)

	return setmetatable({
		-- Define public properties
		step = function (self)
			-- Type checking
			enforce_type("Dijkstra's Algorithm", self)

			-- Runtime error checking
			-- Ensure the priority queue isn't empty
			if priority_queue:is_empty() then
				error("The priority queue is empty")
			end

			-- If the node was already visited, don't add it to the priority queue (meaning its edges won't be cared for)
			-- Insert the nodes based on their distance
			-- When a new node is visited, set its distance equal to the sum of the weights of all the edges taken to reach it
			-- Also, when a new node is visited, add its parent node (the node used to reach it)
			local current_node = priority_queue:dequeue()

			for _, edge in ipairs(current_node.edges) do
				local connected_node = edge.ending_node
				local dist_to_node = edge.weight
				
				if not visited(visited_nodes, connected_node) then
					-- If it wasn't visited then create a slot in the dictionary and add it to the priority queue 
					-- Set initial distance and parent
					local initial_dist = dist_to_node + get_distance(visited_nodes, current_node)

					visited_nodes[connected_node.id] = {dist = initial_dist, parent_node = current_node}
					
					priority_queue:enqueue(connected_node, dist_to_node)
				else
					-- Else, there's already a slot in the dictionary and it doesn't need to be added to the priority queue
					-- But, its distance and parent can be updated IF a different path to this node resulted in a shorter distance
					local new_dist = get_distance(visited_nodes, current_node) + dist_to_node

					if get_distance(visited_nodes, connected_node) > new_dist then
						-- Update the distance and parent
						visited_nodes[connected_node.id].dist = new_dist
						visited_nodes[connected_node.id].parent_node = current_node
					end
				end

			end
		end,

		-- Returns the dictionary of visited nodes
		capture_progress = function ()
			return visited_nodes
		end,

		-- Returns the shortest path as an organized array of nodes (starting node -> ending node) or nil if it doesn't exist
		shortest_path = function ()
			-- Runtime error checking
			-- Make sure the priority queue is empty
			if not priority_queue:is_empty() then
				error("The algorithm is not complete")
			end

			local path = {}
			
			-- Ensure the ending node was reached
			if visited(visited_nodes, ending_node) then
				-- Start with the ending node
				table.insert(path, ending_node)

				local current_parent = get_parent(visited_nodes, ending_node)

				while current_parent ~= nil do
					table.insert(path, 1, current_parent)

					-- Go to the next parent
					current_parent = get_parent(visited_nodes, current_parent)
				end
			else
				-- Return nil if it wasn't visited
				return nil
			end

			return path
		end,

		-- Returns true if the algorithm is complete; false otherwise
		is_complete = function ()
			return priority_queue:is_empty()
		end
	}, DijkstraMT)
end

return Dijkstra