def range(first, last)
  array = []
  first > last ? i = -1 : i = 1
  if first == last
    array << first
    return array
  else
    array << first
    array = array + range(first + i,last)
  end
end

def sum_it(array)
  sum = 0
  array.each { |el| sum += el }
  sum
end

def sum_rec(array)
  if array.count == 1
     array[0]
  else
    array.pop + sum_rec(array)
  end
end

def exp1(base, power)
  if power == 0
    1
  else
    base * exp1(base,power-1)
  end
end

def exp2(base, power)
  if power == 0
    1
  elsif power % 2 == 0
    a = exp2(base, power/2)
    a * a
  else
    a = exp2(base, (power - 1) / 2)
    a * a * base
  end
end

def deep_dup(array)
  array.map do |el|
    if el.is_a?(Array)
      deep_dup(el)
    else
      el
    end
  end
end

def fib_it(n)
  out = []
  i = 0
  until i == n
    case i
    when 0 then out << 0
    when 1 then out << 1
    else
      out << (out[i-1] + out[i-2])
    end
    i +=1
  end
  out
end

def nth_fib(n)
  case n
  when 1
    0
  when 2
    1
  else
    nth_fib(n-1) + nth_fib(n-2)
  end
end

def fib_rec(n)
  out = []
  if n == 0
    out
  else
    out << nth_fib(n)
    out = fib_rec(n-1) + out
  end
  out
end

def binary_search(array, key)
  return nil if array.nil?
  mid = array.count/2
  if array[mid] > key
    binary_search(array[0..mid-1], key)
  elsif array[mid] < key
    mid + binary_search(array[mid..-1], key)
  else
    mid
  end
end

def make_change(num, coins = [25,10,5,1])
  change_combos = []
  coins.each_index do |index|
    change_combos << make_change_greedy(num,coins[index..-1])
  end
  change_combos.sort_by { |el| el.count }[0]
end

def make_change_greedy(num, diff_coins = [25,10,5,1])
  return if num == 0

  change = []
  current_coin = diff_coins[0]

  if num >= current_coin
    amount = num / current_coin
    amount.times { change << current_coin }
    num = num - (current_coin * amount)
  end

  if num > 0
    new_coins = diff_coins.reject { |coin| coin == current_coin }
    change = change + make_change(num, new_coins)
  end
  change
end

def merge_sort(array)
  return array if array.count <= 1

  mid = array.count/2
  left = merge_sort(array[0..mid-1])
  right = merge_sort(array[mid..-1])

  merge(left,right)
end

def merge(arr1, arr2)
  result = []
  until arr1.empty? && arr2.empty?
    if arr1.empty?
      result << arr2.shift
    elsif arr2.empty? || arr1[0] <= arr2[0]
      result << arr1.shift
    else
      result << arr2.shift
    end
  end
  result
end

def subsets(array)
  subs = [array]

  array.each_index do |i|
    new_array = array.select { |x| x if array.index(x) != i }
    subs = subs + subsets(new_array)
  end

  subs.uniq.sort_by { |el| [el.count, el[0]] }
end