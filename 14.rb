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
  end

  def move(dir, data)
    data = data.transpose if DIRECTION[dir][:transpose]
    data = data.map(&:reverse) if DIRECTION[dir][:reverse]
    
    data = data.map do |col|
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

    data = data.map(&:reverse) if DIRECTION[dir][:reverse]
    data = data.transpose if DIRECTION[dir][:transpose]

    data
  end

  def cycle(count, data)
    index = 0

    history = []
    last_index = nil
    count.times do
      break if index >= count
      data = run_sycle(data)
      
      if history.include? data
        index_start_cycle = history.index data

        last_index = (count - index_start_cycle) % (index - index_start_cycle) - 1
        break
      end

      history << data
      index += 1
    end

    (0...last_index).each do |i|
      data = run_sycle(data)
    end
    
    data
  end

  def run_sycle(data)
    data = move(:n, data)
    data = move(:w, data)
    data = move(:s, data)
    data = move(:e, data)
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

res_1 = parser.move(:n, parser.data).map.with_index do |row, i|
                                      row.count('O') * (parser.rows_count - i)
                                    end.sum

puts "FIRST PART: #{res_1}"


parser = DataParser.new

res_2 = parser.cycle(1_000_000_000, parser.data).map.with_index do |row, i|
                                                  row.count('O') * (parser.rows_count - i)
                                                end.sum

puts "SECOND PART: #{res_2}"
