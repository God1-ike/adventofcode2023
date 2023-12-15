def hash(str)
  str.chars.reduce(0) { |acc, c| (((acc + c.ord) * 17) % 256) }
end

history = {}
data = File.read('15_input.txt')
           .split(',')

data.each do |word|
  if history[word].is_a? Hash
    history[word][:count] += 1
    next
  end
  v = hash(word)

  history[word] = { v: v, count: 1 } 
end


res_1 = history.values.sum { |h| h[:v] * h[:count]}

puts "FIRST PART: #{res_1}"

data = File.read('15_input.txt')
           .split(',')
boxes = Array.new(256) { [] }

data.each_with_index do |n, i|
  if n.match('=')
    label, size = n.split('=')
    h = hash(label)
    index = boxes[h].map(&:first).index(label)
    index ? boxes[h][index] = [label, size] : boxes[h] << [label, size]
  else
    label = n.split('-').first
    h = hash(label)
    boxes[h] = boxes[h].reject { |l, _v| l == label }
  end
end

res_2 = boxes.each_with_index.map do |box, i|
            box.each_with_index.map do |(_, value), j|
              (i + 1) * (j + 1) * value.to_i
            end
          end.flatten
             .sum

puts "SECOND PART: #{res_2}"