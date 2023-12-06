# first part

times, distances = File.read('6_input.txt')
                         .split("\n")
                         .map { |s| s.split(': ').last.strip.split(' ').map(&:to_i) }

res = []

distances.count.times do |index|
  time = times[index]
  distance = distances[index]

  discrim = time.pow(2) - 4 * distance
  
  x1 = ((time - Math.sqrt(discrim)) / 2).floor
  x2 = ((time + Math.sqrt(discrim)) / 2).floor

  res << (x2 - x1).abs
end  


puts "FIRST PART: #{res.reduce(&:*)}"

# second part

second_time = times.join.to_i
second_distance = distances.join.to_i

discrim = second_time.pow(2) - 4 * second_distance

x1 = ((second_time - Math.sqrt(discrim)) / 2).floor
x2 = ((second_time + Math.sqrt(discrim)) / 2).floor

puts "SECOND PART: #{(x2 - x1).abs}"
