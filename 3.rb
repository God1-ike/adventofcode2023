class FileParser
  attr_accessor :result

  def initialize(file_path)
    @file_path = file_path
    @result = []
  end

  def parse
    File.readlines(@file_path).each do |line|
      @result << line.strip.each_char.map do |char|
        next char if char.to_i.to_s == char
        next nil if char == '.'

        char
      end
    end

    @result
  end
end


class CustomNumber
  attr_accessor :value, :x_start, :x_end, :y

  def initialize(char, y, x_start)
    @value = char
    @y = y
    @x_start = x_start
    @x_end = x_start
  end

  def add_char(char, index)
    @value += char
    @x_end = index
  end
end

class Analyzer
  attr_accessor :part_numbers, :gears

  MIN_X = 0
  MIN_Y = 0

  def initialize(schema)
    @schema = schema
    @max_x = @schema.first.length - 1
    @max_y = @schema.length - 1
    @part_numbers = []
    @gears = {}
  end

  def select_part_numbers
    number = nil

    @schema.each_with_index do |row, y_index|
      row.each_with_index do |char, x_index|
        if number.nil? && char.to_i.to_s == char
          number = CustomNumber.new(char, y_index, x_index)
        elsif char.to_i.to_s == char
          number.add_char(char, x_index)
        else
          next if number.nil?

          @part_numbers << number.value.to_i if valid_part_numbers?(number)
          number = nil
        end
      end
    end

    @part_numbers
  end

  private

  def valid_part_numbers?(number)
    validated_min_y = number.y == MIN_Y ? MIN_Y : number.y - 1
    validated_max_y = number.y == @max_y ? @max_y : number.y + 1

    validated_min_x = number.x_start == MIN_X ? MIN_X : number.x_start - 1
    validated_max_x = number.x_end == @max_x ? @max_x : number.x_end + 1

    around_number = @schema[validated_min_y..validated_max_y].map do |row|
      row[validated_min_x..validated_max_x]
    end

    save_gear(number,
              around_number,
              validated_min_y,
              validated_min_x
            )

    around_number.flatten.any?(/\D/)
  end

  def save_gear(number, around_number, y_start, x_start)
    around_number.each_with_index do |row_around, y_index|
      row_around.each_with_index do |char, x_index|
        next unless char == '*'

        gear_y = y_start + y_index
        gear_x = x_start + x_index
        key = [gear_y, gear_x].join(':')
        gears[key] ||= []
        gears[key] << number.value.to_i
      end
    end
  end
end


schema = FileParser.new('3_input.txt').parse
analyzer = Analyzer.new(schema)


# first part

puts "FIRST PART: #{analyzer.select_part_numbers.sum}"


# second part

result_2 = analyzer.gears
                   .select { |_, numbers| numbers.count == 2 }
                   .map { |_, numbers| numbers.reduce(&:*) }
                   .flatten
                   .sum

puts "SECOND PART: #{result_2}"
