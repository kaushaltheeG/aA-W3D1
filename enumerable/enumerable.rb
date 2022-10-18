
=begin 
    Extending the Array Class
=end

class Array

    def my_each(&proc)
        #prefivous implemnetation 
        # temp = *self
        # proc.call(temp)
        i = 0
        while i < self.length
            proc.call(self[i])
            i += 1
        end
        self
    end

    def my_select(&proc)
        filtered = []
        self.my_each do |ele|
            p ele
            filtered << ele if proc.call(ele)
        end
        filtered
    end

    def my_reject(&proc)
        rejected = []
        #filtered << proc.call(self.my_each(&proc))
        self.my_each do |ele|
            rejected << ele if !proc.call(ele)
        end
        rejected
    end

    def my_any?(&proc)
        self.my_each do |ele|
            return true if proc.call(ele)
        end
        false
    end

    def my_all?(&proc)
        self.my_each do |ele|
            return false if !proc.call(ele)
        end
        true
    end

    def my_flatten(flatten=[])
        return self if !self.kind_of?(Array)
        self.my_each do |ele|
            !ele.kind_of?(Array) ? flatten << ele : ele.my_flatten(flatten)
        end
        flatten
    end

    def my_zip(*arrs)
        arr_2d = [self, *arrs]
        zipped = Array.new(self.length) {Array.new(arr_2d.length)}
        #p zipped
        arr_2d.each.with_index do |arr|
            arr.each.with_index do |ele, i| 
                zipped[i].pop if zipped[i]
                zipped[i].unshift(ele) if zipped[i]
            end
        end
        zipped
    end

    def my_rotate(num=1)
        if num.positive?
            while num > 0
                #p num
                val = self.shift
                self << val
                #p self
                num -= 1
            end
            #return self
            #p self
        else
            while num < 0 
                val = self.pop
                self.unshift(val)
                num += 1
            end
        end
        self
    end

    def my_join(separator="")
        new_str = ""

        self.each.with_index do |ele, i|
            temp = i != self.length-1 ? ele.to_s + separator : ele.to_s
            new_str += temp
        end
        new_str
    end

    def my_reverse
        last_idx = self.length-1
        new_arr = []
        last_idx.downto(0).each do |i|
            new_arr << self[i]
        end
        new_arr
    end



end

# a = [1, 2, 3]
    # return_value = [1, 2, 3].my_each do |num|
    #  puts num
    # end.my_each do |num|
    #  puts num
    # end
    # # => 1
    #     2
    #     3
    #     1
    #     2
    #     3

# p return_value  # => [1, 2, 3]
    # p a.my_select { |num| num > 1 } # => [2, 3]
    # p a.my_select { |num| num == 4 } # => []

# a = [1, 2, 3]
    # p a.my_reject { |num| num > 1 } # => [1]
    # p a.my_reject { |num| num == 4 } # => [1, 2, 3]
    # p a.my_any? { |num| num > 1 } # => true
    # p a.my_any? { |num| num == 4 } # => false
    # p a.my_all? { |num| num > 1 } # => false
    # p a.my_all? { |num| num < 4 } # => true

# p [1, 2, 3, [4, [5, 6]], [[[7]], 8]].my_flatten # => [1, 2, 3, 4, 5, 6, 7, 8]
    # a = [ 4, 5, 6 ]
    # b = [ 7, 8, 9 ]
    # p [1, 2, 3].my_zip(a, b) # => [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
    # p a.my_zip([1,2], [8])   # => [[4, 1, 8], [5, 2, nil], [6, nil, nil]]
    # p [1, 2].my_zip(a, b)    # => [[1, 4, 7], [2, 5, 8]]

    # c = [10, 11, 12]
    # d = [13, 14, 15]
    # p [1, 2].my_zip(a, b, c, d)    # => [[1, 4, 7, 10, 13], [2, 5, 8, 11, 14]]

#

   #p a.my_rotate         #=> ["b", "c", "d", "a"]
    #p a.my_rotate(2)      #=> ["c", "d", "a", "b"]
    #p a.my_rotate(-3)     #=> ["b", "c", "d", "a"]
    #p a.my_rotate(15)     #=> ["d", "a", "b", "c"]

#a = [ "a", "b", "c", "d" ]
    # p a.my_join         # => "abcd"
    # p a.my_join("$")    # => "a$b$c$d"

# p [ "a", "b", "c" ].my_reverse   #=> ["c", "b", "a"]
#     p [ 1 ].my_reverse               #=> [1]

=begin
my_each:
    Extend the Array class to include a method named my_each that takes a block, calls the block on every element of the array, 
    and returns the original array. 
    Do not use Enumerable's each method. I want to be able to write:

    return_value = [1, 2, 3].my_each do |num|
    puts num
    end.my_each do |num|
    puts num
    end
    # => 1
        2
        3
        1
        2
        3

    p return_value  # => [1, 2, 3]

my_select:
    Now extend the Array class to include my_select that takes a block and returns a new array containing only elements that satisfy the block. 
    Use your my_each method!

    a = [1, 2, 3]
    a.my_select { |num| num > 1 } # => [2, 3]
    a.my_select { |num| num == 4 } # => []

my_reject:
    Write my_reject to take a block and return a new array excluding elements that satisfy the block.
    a = [1, 2, 3]
    a.my_reject { |num| num > 1 } # => [1]
    a.my_reject { |num| num == 4 } # => [1, 2, 3]

My Any
    Write my_any? to return true if any elements of the array satisfy the block and my_all? to return true only if all elements satisfy the block.
    a = [1, 2, 3]
    p a.my_any? { |num| num > 1 } # => true
    p a.my_any? { |num| num == 4 } # => false
    p a.my_all? { |num| num > 1 } # => false
    p a.my_all? { |num| num < 4 } # => true


My Flatten:
    my_flatten should return all elements of the array into a new, one-dimensional array. Hint: use recursion!
    [1, 2, 3, [4, [5, 6]], [[[7]], 8]].my_flatten # => [1, 2, 3, 4, 5, 6, 7, 8]

My Zip:
    Write my_zip to take any number of arguments. It should return a new array containing self.length elements. 
    Each element of the new array should be an array with a length of the input arguments + 1 and contain the merged elements at that index. 
    If the size of any argument is less than self, nil is returned for that location.
    a = [ 4, 5, 6 ]
    b = [ 7, 8, 9 ]
    p [1, 2, 3].my_zip(a, b) # => [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
    p a.my_zip([1,2], [8])   # => [[4, 1, 8], [5, 2, nil], [6, nil, nil]]
    p [1, 2].my_zip(a, b)    # => [[1, 4, 7], [2, 5, 8]]

    c = [10, 11, 12]
    d = [13, 14, 15]
    p [1, 2].my_zip(a, b, c, d)    # => [[1, 4, 7, 10, 13], [2, 5, 8, 11, 14]]

my_rotate
    Write a method my_rotate that returns a new array containing all the elements of the original array in a rotated order. 
    By default, the array should rotate by one element. If a negative value is given, the array is rotated in the opposite direction.
    a = [ "a", "b", "c", "d" ]
    p a.my_rotate         #=> ["b", "c", "d", "a"]
    p a.my_rotate(2)      #=> ["c", "d", "a", "b"]
    p a.my_rotate(-3)     #=> ["b", "c", "d", "a"]
    p a.my_rotate(15)     #=> ["d", "a", "b", "c"]


My Join
    my_join returns a single string containing all the elements of the array, separated by the given string separator. 
    If no separator is given, an empty string is used.

    a = [ "a", "b", "c", "d" ]
    p a.my_join         # => "abcd"
    p a.my_join("$")    # => "a$b$c$d"

My Reverse
    Write a method that returns a new array containing all the elements of the original array in reverse order. 
    p [ "a", "b", "c" ].my_reverse   #=> ["c", "b", "a"]
    p [ 1 ].my_reverse               #=> [1]
    
=end



