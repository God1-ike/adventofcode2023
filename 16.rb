input = File.read('16_input.txt')
            .split("\n")
            .map(&:strip)
            .map { |l| l.chars }

def run(input, start_beam)
  beams = [start_beam]
  energized = input.map { |l| l.map { false } }
  energized_dirs = {}
  exit_flag = true

  while beams.any? && exit_flag
    exit_flag = false

    new_beams = []

    beams.each do |beam|
      beam_key = beam.flatten.join(',')
      if energized_dirs[beam_key]
        next
      else
        energized_dirs[beam_key] = true
        exit_flag = true
      end

      direction, position = beam
      direction_y, direction_x = direction
      position_y, position_x = position

      position_y += direction_y
      position_x += direction_x

      if position_y.negative? || position_y == input.count || position_x.negative? || position_x == input[0].count
        next
      end

      energized[position_y][position_x] = true

      char = input[position_y][position_x]

      if char == '.'
        new_beams.push([[direction_y, direction_x], [position_y, position_x]])
      elsif char == '\\'
        prev_direction_y = direction_y
        direction_y = direction_x
        direction_x = prev_direction_y
        new_beams.push([[direction_y, direction_x], [position_y, position_x]])
      elsif char == '/'
        prev_direction_y = direction_y
        direction_y = -direction_x
        direction_x = -prev_direction_y
        new_beams.push([[direction_y, direction_x], [position_y, position_x]])
      elsif (char == '|' && direction_x.zero?) || (char == '-' && direction_y.zero?)
        new_beams.push([[direction_y, direction_x], [position_y, position_x]])
      elsif char == '|'
        new_beams.push([[-1, 0], [position_y, position_x]])
        new_beams.push([[1, 0], [position_y, position_x]])
      elsif char == '-'
        new_beams.push([[0, -1], [position_y, position_x]])
        new_beams.push([[0, 1], [position_y, position_x]])
      end
    end

    beams = new_beams
  end

  energized.sum { |l| l.count(true) }
end

res_1 = run(input, [[0, 1], [0, -1]])

puts "FIRST PART: #{res_1}"

res_2 = 0

input.each.with_index do |line, y|
  res_2 = [res_2, run(input, [[0, 1], [y, -1]])].max
  res_2 = [res_2, run(input, [[0, -1], [y, line.count]])].max
end

input[0].each.with_index do |c, x|
  res_2 = [res_2, run(input, [[1, 0], [-1, x]])].max
  res_2 = [res_2, run(input, [[-1, 0], [input.count, x]])].max
end

puts "SECOND PART: #{res_2}"