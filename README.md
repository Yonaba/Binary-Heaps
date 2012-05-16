#Binary-Heaps#
Implementation of *binary heaps* data structure in pure Lua

	
##Usage##
Add 'binary_heap.lua' file inside your project.
Call it using require command.
It will return a table containing a set of functions, acting as a class.
	
##Functions Overview##
		heap:new()  : Returns a new heap ( a Min-Heap by default).
		heap()      : Same as heap:new()
		heap:empty() : Checks if a heap is empty.
		heap:clear() : Clears a heap
		heap:leftChildIndex(index) : Returns the left child index of element at position index in the heap
		heap:rightChildIndex(index) : Returns the right child index of element at position index in the heap
		heap:parentIndex(index) : Returns the parent index of element at position index in the heap
		heap:insert(value,linkedData) : Inserts value with linked data in the heap and percolates it up at its proper place.
		heap:pop() : Pops the top element, reorders the heap and returns this element unpacked : value first then data linked
		heap:checkIndex() : checks existence of an element at position index in the heap.
		heap:reset(function) : Reorders the current heap regards to the new comparison function given as argument
		heap:merge(other) : merge the current heap with another
		heap:isValid() : Checks if a heap is valid

##Additionnal features##
		h1+h2 : Returns a new heap with all data stored inside h1 and h2 heaps
		tostring(h) : Returns a string representation of heap h
		print(h) : Prints current heap h as a string

By default, you create Min-heaps. If you do need 'Max-heaps', you can easy do it this way:
		local myHeap = heap:new()
		myHeap.sort = function(a,b) return a>b end
		
#Documentation used#
* [Algolist.net data structure course][]
* [Victor S.Adamchik's Lecture on Cs.cmu.edu][]
* [RPerrot's Article on Developpez.com][]

##License##
This work is under MIT-LICENSE
Copyright (c) 2012 Roland Yonaba

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

[Algolist.net data structure course]: http://www.algolist.net/Data_structures/Binary_heap/Array-based_int_repr
[Victor S.Adamchik's Lecture on Cs.cmu.edu]: http://www.cs.cmu.edu/~adamchik/15-121/lectures/Binary%20Heaps/heaps.html
[RPerrot's Article on Developpez.com]: http://rperrot.developpez.com/articles/algo/structures/arbres/