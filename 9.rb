# first part

class Sensor
  attr_accessor :seq

  INSTR_MAPPER = {
    'R' => :last,
    'L' => :first
  }

  def initialize
    @seq = []
    parse_file
    prepare_all_seq
    calc_last_num_seq
  end

  private

  def parse_file
    File.read('9_input.txt')
        .split("\n")
        .each { |s| @seq << [s.split(' ').map(&:to_i)] }
  end

  def calc_last_num_seq
    @seq.each do |row_seq|
      reverse_row_seq = row_seq.reverse

      reverse_row_seq.each_with_index do |diff_seq, i|
        next if diff_seq.all?(0)

        diff_seq.push(diff_seq.last + reverse_row_seq[i - 1].last)
        diff_seq.unshift(diff_seq.first - reverse_row_seq[i - 1].first)
      end
    end
  end

  def prepare_all_seq
    @seq.each_with_index do |seq, index|
      until seq.last.all?(0) do
        seq << next_seq(seq.last)
      end
    end
  end

  def next_seq(prev_seq)
    new_seq = []

    prev_seq.count.times.each do |i|
      break if i + 1 >= prev_seq.count

      new_seq << prev_seq[i + 1] - prev_seq[i]
    end

    new_seq
  end
end


sensor = Sensor.new

puts "FIRST PART: #{sensor.seq.map { |e| e.first.last }.sum}"

# # second part

sensor = Sensor.new

puts "SECOND PART: #{sensor.seq.map { |e| e.first.first }.sum}"
