class DataParser
  attr_accessor :data, :rows_count

  DIRECTION = {
    n: { transpose: true, reverse: false },
    w: { transpose: false, reverse: false },
    s: { transpose: true, reverse: true },
    e: { transpose: false, reverse: true }
  }

  def initialize
    @data = parse
    @rows_count = @data.count
    @history = []
  end

  def move(dir)
    @data = @data.transpose if DIRECTION[dir][:transpose]
    @data = @data.map(&:reverse) if DIRECTION[dir][:reverse]
    
    @data = @data.map do |col|
              last_empty_i = 0
              i = 0
              col = col.each_with_object([]) do |v, acc|

                if col[i..].count('O') == 0
                  break acc += col[i..]
                end

                if v == 'O'
                  v = if last_empty_i == i
                        'O'
                      else
                        acc[last_empty_i] = 'O'
                        '.'
                      end

                  last_empty_i += 1
                elsif v == '#'
                  last_empty_i = i + 1
                end

                i += 1
                acc << v
              end

              col
            end

    @data = @data.map(&:reverse) if DIRECTION[dir][:reverse]
    @data = @data.transpose if DIRECTION[dir][:transpose]

    @data
  end

  def cycle(count)

    count.times do |i|
      p i / 1000 if i % 1000 == 0
      move(:n)
      move(:w)
      move(:s)
      move(:e)
    end
    
    @data
  end

  private

  def parse
    File.read('14_input.txt')
        .lines
        .map(&:strip)
        .map { |l| l.split('')}
  end  
end

parser = DataParser.new

res_1 = parser.move(:n).map.with_index do |row, i|
                          row.count('O') * (parser.rows_count - i)
                        end.sum

puts "FIRST PART: #{res_1}"


parser = DataParser.new

res_2 = parser.cycle(1000000000).map.with_index do |row, i|
                          row.count('O') * (parser.rows_count - i)
                        end.sum

parser.data.each { |e| p e}               

puts "SECOND PART: #{res_2}"
