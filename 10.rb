# first part
require 'geokit'

class Map
  attr_accessor :input, :curr_loop

  def initialize
    @input = parse_file
    setup_start
  end

  def build_loop
    @curr_loop = [@start_point]

    direction = if ['7', '|', 'F'].include? @input[@start_y - 1][@start_x]
      1
    elsif ['F', '-', 'L'].include? input[@start_y][@start_x - 1]
      2
    else
      3
    end

    while true
      break if @curr_loop.last == @start_point && @curr_loop.count > 1

      new_direction = move(direction)
      
      # вводим новый символ для 2го задания стены
      if direction == 4 || new_direction == 1 || new_direction == 4 || direction == 1
        @input[@curr_loop.last[0]][@curr_loop.last[1]] = '!'
      else
        @input[@curr_loop.last[0]][@curr_loop.last[1]] = '_'
      end


      direction = new_direction
    end
  end

  def calc_area
    count = 0
    points = @curr_loop.map {|e| Geokit::LatLng.new(e[0], e[1])}
    polygon = Geokit::Polygon.new(points)

    (0...@input.count).each do |y|
      p y
      (0...@input.first.length).each do |x| 
        next if @curr_loop.include?([y, x])

        new_p = Geokit::LatLng.new(y, x)
        count += 1 if polygon.contains?(new_p)
      end
    end

    count
  end

  private

  def parse_file
    File.read('10_input.txt')
        .split("\n")
  end

  def setup_start
    @start_y = @input.find_index { |line| line.index 'S' }
    @start_x = @input[@start_y].index('S')
    @start_point = [@start_y, @start_x]
  end

  def move(direction)
    current_poz = @curr_loop.last
    case direction
    # down
    when 1
      new_poz = [current_poz[0] - 1, current_poz[1]]
      @curr_loop << new_poz
      case @input[new_poz[0]][new_poz[1]]
      when '7'
        direction = 2
      when 'F'
        direction = 3
      end
    # left
    when 2
      new_poz = [current_poz[0], current_poz[1] - 1]
      @curr_loop << new_poz
      case @input[new_poz[0]][new_poz[1]]
      when 'L'
        direction = 1
      when 'F'
        direction = 4
      end
    # right
    when 3
      new_poz = [current_poz[0], current_poz[1] + 1]
      @curr_loop << new_poz
      case input[new_poz[0]][new_poz[1]]
      when 'J'
        direction = 1
      when '7'
        direction = 4
      end
    # up
    when 4
      new_poz = [current_poz[0] + 1, current_poz[1]]
      @curr_loop << new_poz
      case input[new_poz[0]][new_poz[1]]
      when 'L'
        direction = 3
      when 'J'
        direction = 2
      end
    end

    direction
  end
end


map = Map.new
map.build_loop

puts "FIRST PART: #{map.curr_loop.count / 2}"

# # second part

puts "SECOND PART: #{map.calc_area}"
# puts "SECOND PART: #{sensor.seq.map { |e| e.first.first }.sum}"
