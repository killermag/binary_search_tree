class Node
  attr_accessor :value, :left, :right
  include Comparable

  def initialize (value = nil,left = nil, right = nil )
    @value = value
    @left = left
    @right = right
  end

end