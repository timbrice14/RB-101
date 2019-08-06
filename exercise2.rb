def is_odd?(number)
  number.remainder(2) == 0 ? false  : true
end

puts is_odd?(2)
puts is_odd?(5)
puts is_odd?(-17)
puts is_odd?(0)
