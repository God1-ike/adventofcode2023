# first part
require 'geokit'

class Galaxy
  attr_accessor :actual_map, :galaxies, :empty_rows, :empty_columns

  def initialize
    @actual_map = parse_file
  end

  def calc_distance(galaxy_first, galaxy_second, diff)
    len = (galaxy_first[0] - galaxy_second[0]).abs + (galaxy_first[1] - galaxy_second[1]).abs

    col_range = galaxy_first[0] < galaxy_second[0] ? galaxy_first[0]...galaxy_second[0] : galaxy_second[0]...galaxy_first[0]

    len += (diff - 1) * @empty_columns.count { |col| col_range.include? col }

    line_range = galaxy_first[1] < galaxy_second[1] ? galaxy_first[1]...galaxy_second[1] : galaxy_second[1]...galaxy_first[1]

    len += (diff - 1) * @empty_rows.count { |row| line_range.include? row }

    len
  end

  private

  def parse_file
    input = File.read('11_input.txt')
        .split("\n")

    @empty_rows = input.filter_map.with_index do |line, index|
      line.count('#') == 0 ? index : nil
    end

    @empty_columns = (0...input[0].length).filter do |column|
      input.all? { |row| row[column] == '.' }
    end

    @galaxies = []
    input.each.with_index do |line, y|
      line.chars.each.with_index { |char, x| @galaxies << [x, y] if char == '#' }
    end
  end
end


map = Galaxy.new

result_1 = map.galaxies.map.with_index do |first_galaxy, i|
              map.galaxies[i..].sum do |second_galaxy|
                next 0 if second_galaxy == first_galaxy

                map.calc_distance(first_galaxy, second_galaxy, 2)
              end
           end.sum

puts "FIRST PART: #{result_1}"

result_2 = map.galaxies.map.with_index do |first_galaxy, i|
  map.galaxies[i..].sum do |second_galaxy|
    next 0 if second_galaxy == first_galaxy

    map.calc_distance(first_galaxy, second_galaxy, 1000000)
  end
end.sum

puts "SECOND PART: #{result_2}"
