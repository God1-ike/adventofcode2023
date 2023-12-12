class Parser
  attr_accessor :data, :aggr

  def initialize
    @data = parse
    @aggr = {}
  end

  def counts(springs, counts)
    return @aggr[[springs, counts]] if @aggr[[springs, counts]]

    springs += '|' unless springs.end_with? '|'

    return springs.count('#') == 0 ? 1 : 0 if counts.size == 0

    return 0 if (counts.sum + counts.size) > springs.size

    first_spring_size = counts[0]
    next_sprigns_sizes = counts[1..-1]

    first_spring_index = springs.chars.find_index('#') || springs.size - 1

    total = (0..first_spring_index).to_a
                                  .select { |i| p ;springs[i..] =~/^[#?]{#{first_spring_size}}[\.\?\|]/ }
                                  .map { |i| counts(springs[(i + first_spring_size + 1)..] || '', next_sprigns_sizes) }
                                  .sum
    @aggr[[springs, counts]] = total
    total
  end

  private

  def parse
    File.read('12_input.txt')
                    .lines
                    .map(&:strip)
                    .map do |line|
                        springs, nums = line.split
                        nums = nums.split(',').map(&:to_i)
                        {
                          springs: springs, 
                          nums: nums
                        }
                      end
  end  
end

parser = Parser.new
data = parser.data

res_1 = data.map { |d| parser.counts(d[:springs], d[:nums]) }.sum

puts "FIRST PART: #{res_1}"

parser = Parser.new
data = parser.data


res_2 = data.map do |d| 
  springs = 5.times.map{ d[:springs] }.join('?')
  parser.counts(springs, d[:nums] * 5)
end.sum

puts "SECOND PART: #{res_2}"