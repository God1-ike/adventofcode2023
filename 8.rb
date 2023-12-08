# first part

class Map
  attr_accessor :positions, :instruction

  INSTR_MAPPER = {
    'R' => :last,
    'L' => :first
  }

  def initialize
    @instruction = []
    @positions = {}
    parse_hands

    @instsr_max_index = @instruction.length - 1
  end

  def steps_count(current_poz:, end_poz:)
    count = 0
    instructon_position = 0

    while(current_poz != end_poz) do 
      current_poz = @positions[current_poz].send(@instruction[instructon_position])

      if instructon_position == @instsr_max_index
        instructon_position = 0
      else
        instructon_position += 1
      end

      count += 1
    end

    return count
  end

  def steps_count_lvl_2(current_poz)
    count = 0
    instructon_position = 0

    while(!current_poz.match?(/Z$/)) do 
      current_poz = @positions[current_poz].send(@instruction[instructon_position])

      if instructon_position == @instsr_max_index
        instructon_position = 0
      else
        instructon_position += 1
      end

      count += 1
    end

    return count
  end

  private

  def parse_hands
    file = File.read('8_input.txt')
               .split("\n")
               .each do |s| 
                next if s.empty?

                if @instruction.empty?
                  @instruction = s.split('').map { |v| INSTR_MAPPER[v] }
                  next
                end

                key, values = s.split(" = ")

                @start=

                @positions[key] = values.gsub(/[(|)]/, '')
                                       .split(', ')
              end
  end
end


map = Map.new

puts "FIRST PART: #{map.steps_count(current_poz: 'AAA', end_poz: 'ZZZ')}"

# # second part

map = Map.new

current_poz = map.positions.keys.select { |v| v.match?(/A$/) }

values = current_poz.map { |v| map.steps_count_lvl_2(v) }

puts "SECONT PART: #{values.reduce(1, :lcm)}"
