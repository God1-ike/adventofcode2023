DIRECTION = {
  'R' => [0, 1],
  'L' => [0, -1],
  'D' => [-1, 0],
  'U' => [1, 0]
}
input = File.read('18_input.txt')
             .split("\n")
             .map(&:strip)
             .map { |l| l.split(' ') }

points = [[0, 0]]

current_y = 0
current_x = 0
input.each do |(direction, step_count, color)|
  diff_y = DIRECTION[direction][0]
  diff_x = DIRECTION[direction][1]
  step_count.to_i.times do
    current_y += diff_y
    current_x += diff_x
    points << [current_y, current_x]
  end
end

res_1 = points.count.times.map do |i|
  if points.count - 1 == i
    points[i][1] * points[0][0] - points[i][0] * points[0][1] 
  else
    points[i][1] * points[i + 1][0] - points[i][0] * points[i + 1][1] 
  end
end.sum
   .abs + points.count + 1


puts "FIRST PART: #{ res_1 / 2 }"

DIRECTION_COLOR = {
  '0' => [0, 1],
  '2' => [0, -1],
  '1' => [-1, 0],
  '3' => [1, 0]
}

points = [[0, 0]]

current_y = 0
current_x = 0
input.each do |(_direction, _step_count, color)|
  color = color.gsub(/[(|#|)]/, '')

  diff_y = DIRECTION_COLOR[color[5]][0]
  diff_x = DIRECTION_COLOR[color[5]][1]

  color[..4].to_i(16).to_i.times do
    current_y += diff_y
    current_x += diff_x
    points << [current_y, current_x]
  end
end

res_2 = points.count.times.map do |i|
  if points.count - 1 == i
    points[i][1] * points[0][0] - points[i][0] * points[0][1] 
  else
    points[i][1] * points[i + 1][0] - points[i][0] * points[i + 1][1] 
  end
end.sum
   .abs + points.count + 1


puts "SECOND PART: #{ res_2 / 2 }"
