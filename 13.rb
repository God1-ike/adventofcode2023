class PuzzlesParser
  attr_accessor :puzzles, :mirrors

  def initialize(diffs_count)
    @diffs_count = diffs_count
    @puzzles = []
    @mirrors = []
    parse
  end

  private

  def parse
    puzzle = []

    curr_type = :col_index

    File.read('13_input.txt')
        .lines
        .map(&:strip)
        .each do |line|
          if line.empty?
            mirror = find_mirror(puzzle, :row_index)
            columns_puzzle = (0...puzzle.first.length).map {|i| puzzle.map { |r| r[i]}.join }
            mirror.merge!(find_mirror(columns_puzzle, :col_index))

            @mirrors << mirror
            @puzzles << puzzle

            puzzle = []
          else
            puzzle << line
          end
        end

    mirror = find_mirror(puzzle, :row_index)
    columns_puzzle = (0...puzzle.first.length).map {|i| puzzle.map { |r| r[i]}.join }
    mirror.merge!(find_mirror(columns_puzzle, :col_index))

    @mirrors << mirror
    @puzzles << puzzle


    nil
  end  

  def find_mirror(puzzle, type)
    mirror_index = nil
    
    puzzle.each_with_index do |line, check_line_index|
      mirror_index = check_line_index + 1

      if mirror_index > puzzle.count / 2
        left_part = puzzle[(check_line_index + 1)..]
        right_part = puzzle[..check_line_index].reverse
      else
        left_part = puzzle[..check_line_index].reverse
        right_part = puzzle[(check_line_index + 1)..]
      end

      mirror_index = nil if right_part.empty? || left_part.empty?
      diff_count = 0
      left_part.each_with_index do |left_part, left_part_index|
                                  diff_count += left_part.split('')
                                                        .zip(right_part[left_part_index].split(''))
                                                        .count { |e1, e2| e1 != e2 }
                                  next if diff_count <= @diffs_count
                                  
                                  mirror_index = nil
                                  break
                                end

      return { type => mirror_index.to_i } if mirror_index != nil && diff_count == @diffs_count
    end

    { type => mirror_index.to_i }
  end
end

parser = PuzzlesParser.new(0)

puts "FIRST PART: #{parser.mirrors.map {|v| v[:row_index].to_i * 100 + v[:col_index].to_i}.sum}"


parser = PuzzlesParser.new(1)

puts "SECOND PART: #{parser.mirrors.map {|v| v[:row_index].to_i * 100 + v[:col_index].to_i}.sum}"
