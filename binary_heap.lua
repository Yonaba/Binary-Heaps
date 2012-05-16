-- Copyright (c) 2012 Roland Yonaba

--[[
Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

-- An implementation of Binary Heaps data structure in pure Lua
--[[
	Documentation :
	- http://www.algolist.net/Data_structures/Binary_heap/Array-based_int_repr
	- http://www.cs.cmu.edu/~adamchik/15-121/lectures/Binary%20Heaps/heaps.html
	- http://rperrot.developpez.com/articles/algo/structures/arbres/
--]]

local setmetatable = setmetatable
local type = type
local assert = assert
local ipairs,pairs = ipairs,pairs
local floor = math.floor
local tostring = tostring

-- Default sorting function.
-- Used for Min-Heaps creation.
local function f_min(a,b) return a<b end

-- Percolates up datum in the heap recursively
local function percolate_up(self,index)
	local pIndex,tmpNode
	if index > 1 then
		pIndex = self:parentIndex(index)
		if self.nodes[pIndex] then
			if not (self.sort(self.nodes[pIndex].value,self.nodes[index].value)) then
			tmpNode = self.nodes[pIndex]
			self.nodes[pIndex] = self.nodes[index]
			self.nodes[index] = tmpNode
			percolate_up(self,pIndex) -- Recursive call from the parent index
			end
		else
			return
		end
	end
end

-- Percolates down datum in the heap recursively
local function percolate_down(self,index)
	local lfIndex,rtIndex,minIndex,tmpNode
	lfIndex = self:leftChildIndex(index)
	rtIndex = self:rightChildIndex(index)
	if rtIndex > self.size then
		if lfIndex > self.size then return
		else minIndex = lfIndex	end
	else
		if self.sort(self.nodes[lfIndex].value,self.nodes[rtIndex].value) then minIndex = lfIndex
		else minIndex = rtIndex end
	end
	if not self.sort(self.nodes[index].value,self.nodes[minIndex].value) then
	tmpNode = self.nodes[minIndex]
	self.nodes[minIndex] = self.nodes[index]
	self.nodes[index] = tmpNode
	percolate_down(self,minIndex) -- Recursive call from the newly shifted index
	end

end


-- The heap class
local heap = {}
heap.__index = heap
heap.__version = "0.3"

-- Class constructor
-- Returns a new heap [table]
function heap:new()
	return setmetatable( {
						nodes = {}, -- Holds data inside the heap
						size = 0,
						sort = (type(comp) == 'function' and comp or f_min)
						},heap)
end

-- Checks if a heap is empty
-- Return true or false [boolean]
function heap:empty()
	return (self.size==0)
end

-- Gets heap size (the very number of elements stored in the heap)
-- Returns the heap size [number]
function heap:size()
	return self.size
end

-- Clears the heap
-- Returns nothing [nil]
function heap:clear()
	self.nodes = {}
	self.size = 0
end

-- Returns the left child index of the current index
-- Returned index may not be a valid index in the heap
-- Returns this index [number]
function heap:leftChildIndex(index)
	return (2*index)
end

-- Returns the right child index of the current index
-- Returned index may not be a valid index in the heap
-- Returns this index [number]
function heap:rightChildIndex(index)
	return 2*index+1
end

-- Returns the parent index of the current index
-- Returned index may not be a valid index in the heap
-- Returns this index [number]
function heap:parentIndex(index)
	return floor(index/2)
end

-- Inserts a value in the heap as a table {value = value, data = data}
-- <data> Argument is optional and may represent extra information linked to <value> argument.
-- Returns nothing [nil]
function heap:insert(value,data)
	self.size = self.size + 1
	self.nodes[self.size] = {value = value, data = data}
	percolate_up(self,self.size)
end

-- Pops the first element in the heap
-- Returns this element unpacked: value first then data linked
function heap:pop()
	assert(not self:empty(), 'Heap is empty.')
	local root = self.nodes[1]
	self.nodes[1] = self.nodes[self.size]
	self.nodes[self.size] = nil
	self.size = self.size-1
	if self.size>1 then
		percolate_down(self,1)
	end
	return root.value,root.data
end

-- Checks if the given index is valid in the heap
-- Returns the element stored in the heap at that very index [table], otherwise nil. [nil]
function heap:checkIndex(index)
	return self.nodes[index] or nil
end

-- Resets the heap property regards to the comparison function given as argument (Optional)
-- Returns nothing [nil]
function heap:reset(comp)
	self.sort = comp or self.comp
	local nodes = self.nodes
	self.nodes = {}
	self.size = 0
	for i in pairs(nodes) do
		self:insert(nodes[i].value,nodes[i].data)
	end
end

-- Appends a heap contents  to the current one
-- Returns nothing [nil]
function heap:merge(other)
	assert(other:isValid(),'Argument is not a valid heap')
	assert(self.sort(1,2) == other.sort(1,2),'Heaps must have the same sort functions')
	for i,node in ipairs(other.nodes) do
		self:insert(node.value,node.data)
	end
end

-- Shortcut for merging heaps with '+' operator
-- Returns a new heap based on h1+h2 [table]
function heap.__add(h1,h2)
	local h = heap()
	h:merge(h1)
	h:merge(h2)
	return h
end

-- Tests if each element stored in a heap is located at the right place
-- Returns true on success, false on error. [boolean]
function heap:isValid()
	if self.size <= 1 then return true end
	local i = 1
	local lfIndex,rtIndex
	for i = 1,(floor(self.size/2)) do
		lfIndex = self:leftChildIndex(i)
		rtIndex = self:rightChildIndex(i)
			if self:checkIndex(lfIndex) then
				if not self.sort(self.nodes[i].value,self.nodes[lfIndex].value) then
					return false
				end
			end
			if self:checkIndex(rtIndex) then
				if not self.sort(self.nodes[i].value,self.nodes[rtIndex].value) then
					return false
				end
			end
	end
	return true
end


-- (Debug utility) Create a string representation of the current
-- Returns this string to be used with print() or tostring() [string]
function heap.__tostring(self)
	local out = ''
	for k in ipairs(self.nodes) do
		out = out.. (('Element %d - Value : %s\n'):format(k,tostring(self.nodes[k].value)))
	end
	return out
end


-- Shortcut for heap() call.
-- Returns heap class to a require call
return setmetatable(heap,{__call = function(self,...) return self:new(...) end,})

