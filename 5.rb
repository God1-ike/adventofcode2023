require 'benchmark'

class Almanah
  KEYS_MAP = [
    'seeds',
    'seed-to-soil map',
    'soil-to-fertilizer map',
    'fertilizer-to-water map',
    'water-to-light map',
    'light-to-temperature map',
    'temperature-to-humidity map',
    'humidity-to-location map'
  ]

  attr_accessor :result, :seeds

  def initialize(file_path)
    @file_path = file_path
    @seeds = []
    @result = {}
  end

  def seeds_part_2
    @seeds.each_slice(2).map { |e| (e.first..(e.first + e.last - 1)) }
  end

  def parse
    current_map = nil
    File.readlines(@file_path).each do |line|
      next if line.strip.empty?

      map_name, values = line.strip.split(':')

      if KEYS_MAP.include?(map_name)
        @seeds = values.split(' ').map(&:to_i) if map_name == 'seeds'
        current_map = map_name
        next
      end
      first_value, second_value, steps = line.strip.split(' ').map(&:to_i)

      @result[current_map] ||= {}
      @result[current_map][(second_value..(second_value + steps - 1))] = (first_value..(first_value + steps - 1))
    end
  end
end

almanah = Almanah.new('5_input.txt')
almanah.parse

def find_next_map_values(almanah, number, key_map)
  mapped = almanah.result[key_map].select {|k, _| k.include?(number)}
                         .map do |k, v|
                          step = number - k.first
                          (v.first + step)
                         end.flatten.uniq

  return [number] if mapped.empty?

  mapped
end


# first part

bm = Benchmark.realtime do
  result_1 = almanah.seeds.each_with_object({}) do |seed, acc_seeds|
    index = 0
    acc_seeds[seed] = [seed]
    Almanah::KEYS_MAP[1..].each do |key|
      if index == 0
        acc_seeds[seed] << find_next_map_values(almanah, seed, key) 
      else
        acc_seeds[seed] << acc_seeds[seed][index].map {|new_num| find_next_map_values(almanah, new_num, key) }.flatten
      end
      
      index += 1
    end
  end
  puts "FIRST PART: #{result_1.values.map(&:last).flatten.min}"
end

puts "FIRST PART TIME: #{bm}"

# second part

# steps_count = almanah.seeds_part_2.count


def find_next_map_values_by_range(almanah, range, key_map)
  if range.size == 0
    return {
      mapped_numbers: [],
      equal_numbers: [] 
    }
  end
  mapped_numbers = []


  almanah.result[key_map].each do |k, v|
    
    r_start = range.first
    r_end = range.last

    if k.include?(r_start) && k.include?(r_end)

      n_start = v.first + (range.first - k.first)
      mapped_numbers << (n_start..(n_start + range.size - 1))

      return {
        mapped_numbers: mapped_numbers.flatten,
        equal_numbers: [] 
      }
    elsif k.include?(r_start)

      n_start = v.first + (range.first - k.first)
      n_end = v.last
      mapped_numbers << (n_start..n_end)
      range = ((range.first + k.size - 1)..range.last)
    elsif k.include?(r_end)
      n_start = v.first
      n_end = v.first + (range.last - k.first)
      mapped_range = (n_start..n_end)
      mapped_numbers << mapped_range
      range = (range.first..(range.first + (range.size - mapped_range.size -  1)))
    elsif range.include?(k.first) && range.include?(k.last)
      splitted_range_1 = (r_start..(k.first - 1))
      splitted_range_2 = ((k.last + 1)..range.last)
      agg_step_numbers = [{mapped_numbers: [v],equal_numbers: []}]
      agg_step_numbers << find_next_map_values_by_range(almanah, splitted_range_1, key_map)
      agg_step_numbers << find_next_map_values_by_range(almanah, splitted_range_2, key_map)

      return {
        mapped_numbers: agg_step_numbers.map {|e| e[:mapped_numbers]}.flatten,
        equal_numbers: agg_step_numbers.map {|e| e[:equal_numbers]}.flatten
      }
    end

  end

  {
    mapped_numbers: mapped_numbers.flatten,
    equal_numbers: [range]
  }
end

@min_values_2 = nil

bm = Benchmark.realtime do
  almanah.seeds_part_2.each do |seeds_range|
    index = 0
    acc_seeds = [seeds_range]
    Almanah::KEYS_MAP[1..].each do |key|
      if index == 0
        acc_seeds << find_next_map_values_by_range(almanah, seeds_range, key) 

      else
        agg_step_numbers = acc_seeds[index].map do |_, new_ranges| 
                            new_ranges.map { |new_range| find_next_map_values_by_range(almanah, new_range, key)}
                          end.flatten

        acc_seeds << {
          mapped_numbers: agg_step_numbers.map {|e| e[:mapped_numbers]}.flatten,
          equal_numbers: agg_step_numbers.map {|e| e[:equal_numbers]}.flatten
        }
      end
      
      index += 1
    end


    acc_seeds.last.values.flatten.each do |r| 
      @min_values_2 = @min_values_2.nil? ? r.first : [@min_values_2, r.first].min
    end
  end
  puts "SECOND PART: #{@min_values_2}"

end
puts "SECOND PART TIME: #{bm}"
