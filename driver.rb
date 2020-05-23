require_relative 'Tree'
  
puts "1. Create a binary search tree from an array of random numbers (`Array.new(15) { rand(1..100) }`)"

tree = Tree.new(Array.new(15) { rand(1..100) })
print tree.array

puts "\n2. Confirm that the tree is balanced by calling `#balanced?`"
puts "Tree balanced? #{tree.balanced?}"
tree.pretty_print

puts "3. Print out all elements in level, pre, post, and in order"
[:preorder,:postorder,:inorder].each do |x|
  print "#{x} :"
  tree.send(x) {|y| print " " + y.to_s}
  puts  
end 


puts "4. try to unbalance the tree by adding several numbers > 100"
array = Array.new(5) {rand(1...100)} 
array.each do |x| 
  tree.insert(x)
end 
tree.pretty_print

puts "5. Confirm that the tree is unbalanced by calling `#balanced?"
puts "Tree balanced? #{tree.balanced?}"

puts "6. Balance the tree by calling rebalance!`"
tree.rebalance!

puts "7. Confirm that the tree is balanced by calling `#balanced?`"
puts "Tree balanced? #{tree.balanced?}"
tree.pretty_print

puts "8. Print out all elements in level, pre, post, and in order"
[:level_order,:preorder,:postorder,:inorder].each do |x|
  print "#{x} :"
  tree.send(x) {|y| print " " + y.to_s}
  puts  
end 

