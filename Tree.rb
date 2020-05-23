require 'pry-byebug'
require 'rubocop'
require_relative "Node"

class Tree
  attr_accessor :array, :root, :current

  def initialize(array = nil)
    @array = array.sort.uniq
    @root = build_tree
  end

  def build_tree(array=@array)
    if array.length < 2 
      return Node.new(array[0])
    else 
      mid = array.length / 2 
      root = Node.new(array[mid])
      root.right = build_tree(array[mid+1..-1]) unless array[mid+1..-1].empty?    
      root.left = build_tree(array[0...mid]) unless array[0...mid].empty?
    end
    return root
  end 

  def has_right (node)
    return true if node.right != nil
    return false
  end

  def has_left (node)
    return true if node.left != nil
    return false
  end

  def empty?(node)
    if !has_left(node) && !has_right(node)
      return true
    else
      return false
    end
  end

  def r_empty?
    return true if @current.right == nil
    return false
  end

  def l_empty?
    return true if @current.left == nil
    return false
  end
  
  def size
    return @array.length
  end
  
  def delete (value, node = @root)
    # These are the return statements/or the base case, the return is made when a child of a node is equal to the value
    return if node.value == value && node != root
    delete(value , node.right) if node.right && @root.value != value 
    delete(value , node.left) if node.left && @root.value != value 
    
      if @root.value != value
        if has_right(node) && node.right.value == value ||  has_left(node) && node.left.value == value
          node.right.value == value ? temp = node.right : temp = node.left
        end
      else
        temp = @root
      end

      unless temp.nil?

       if temp.right == nil && temp.left == nil
         if node.value == @root.value 
           @root = nil 
           return 
         end 
         node.right == temp ? node.right = nil : node.left = nil
         return
       end

       if (temp.right != nil && temp.left == nil) || (temp.left != nil && temp.right == nil)
         if node != @root
         node.right == temp ? (has_left(temp) ? node.right = temp.left : node.right = temp.right) : (has_left(temp) ? node.left = temp.left : node.left = temp.right)
         else
           has_right(@root) ? @root = @root.right : @root = @root.left
         return
         end
       end

       if temp.right != nil && temp.left != nil
         parent = temp.right
         unless !has_left(parent)
         child = parent.left
         loop do
           break if child.left == nil
           parent,child = child,child.left
         end
         unless node == root
         node.right == temp ? node.right.value = child.value : node.left.value = child.value
         else
           node.value = child.value
         end
         has_right(child) ? parent.left = child.right : parent.left = nil
         else
           unless node == root
           if node.right == temp
             node.right.value,node.right.right = parent.value,parent.right
           else
             node.left.value,node.left.right = parent.value,parent.right
           end
           else
             node.value,node.right = parent.value,parent.right
           end
       end
      end 
      return
    end


  end

  def insert(value)
    node = root
    loop {
      if value > node.value
        unless has_right(node)
          node.right = Node.new
          node.right.value = value
          return
        end
      node = node.right
        redo
      else
        unless has_left(node)
          node.left = Node.new
          node.left.value = value
          return
        end
        node = node.left
        redo
      end

    }
  end


  def find(value,node = root)

    return node if node.value == value
    a = find(value,node.right) if has_right(node)
    b = find(value,node.left) if has_left(node)
    if a != nil
      return a if a.value == value
    elsif b != nil
      return b if b.value == value
    end

  end

  def level_order(node = root)
    new_array,queue = [],[]
    queue << node
    block_given? ? yield(queue[0].value,queue[0]) : new_array << queue[0].value
    loop {
      break if queue.empty?
      queue << queue[0].left if has_left(queue[0])
      queue << queue[0].right if has_right(queue[0])
      queue.delete_at(0)
      if block_given?
      yield( queue[0].value,queue[0]) unless queue.empty?
      else
        new_array << queue[0].value unless queue.empty?
      end
    }
    return new_array unless block_given?
  end

  def pretty_print(node = root, prefix="", is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? "│   " : "    "}", false) if node.right
    puts "#{prefix}#{is_left ? "└── " : "┌── "}#{node.value.to_s}"
    pretty_print(node.left, "#{prefix}#{is_left ? "    " : "│   "}", true) if node.left
  end

  def depth(value = @root.value,node=@root)
    node = find(value) unless node.value == value 
    return 1 if node.right == nil && node.left == nil 
    a = depth(node.left.value,node.left) + 1 if node.left 
    b = depth(node.right.value,node.right) + 1 if node.right
    a = 0 if a == nil 
    b = 0 if b == nil 
    a > b ? a : b  
  end 

  def balanced?(value=@root.value)
    node = find(value) 
    if node != nil 
      node.left ? left = depth(node.left.value,node.left) : left = 0
      node.right ? right = depth(node.right.value,node.right) : right = 0 
      (left - right).abs <= 1 ? true : false 
    else 
      puts "You were trying to access a node that doesnt exist :("
    end
  end
  
  def rebalance! 
    return "Already balanced :)" if balanced?
    @array = level_order.sort.uniq
    @root = build_tree() 
  end 

  [:inorder,:postorder,:preorder].each do |method_name| 
    define_method(method_name) do |node = @root , arr = [] , &b| 
      b ? b.call(node.value) : arr << node.value if method_name == :postorder  
      self.send(method_name,node.left,arr,&b) if node.left
      b ? b.call(node.value) : arr << node.value if method_name == :inorder 
      self.send(method_name,node.right,arr,&b) if node.right 
      b ? b.call(node.value) : arr << node.value if method_name == :preorder 
    end 
  end 

end