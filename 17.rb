input = File.read('17_input.txt')
            .split("\n")
            .map(&:strip)
            .map { |l| l.split('').map(&:to_i) }

class ShortPath
  attr_accessor :new_nodes, :grid, :size
  DIRECTIONS = { n: [-1, 0], s: [1, 0], w: [0, -1], e: [0, 1] }

  INVALI_DIRECTIONS = {
    n: :s,
    s: :n,
    e: :w,
    w: :e
  }
  
  def initialize(input, min_step, max_step)
    @new_nodes = [[0, 0, nil, 0]] # ключ формируется: строка, колонка, направление, номер шага по прямой
    @grid = { new_nodes[0] => 0 }
    @size = input.length
    @input = input
    @min_step = min_step
    @max_step = max_step
  end

  def build_grid
    until @new_nodes.empty?
      next_nodes = []

      @new_nodes.each do |row, col, direction, step|
        grid_key = [row, col, direction, step]

        current = @grid[grid_key]

        DIRECTIONS.each do |new_dir, diff|
          next if INVALI_DIRECTIONS[direction] == new_dir
          next if grid.size != 1 && direction != new_dir && step < @min_step

          new_step = new_dir == direction ? step + 1 : 1

          next if new_step > @max_step

          new_row = row + diff[0]
          new_col = col + diff[1]

          next if new_row.negative? || new_row == @size || new_col.negative? || new_col == @size

          new_grid_key = [new_row, new_col, new_dir, new_step]
          current_min = @grid[new_grid_key]

          if current_min.nil? || (current_min && (current + @input[new_row][new_col] < current_min))
            @grid[new_grid_key] = current + @input[new_row][new_col]
            next_nodes << new_grid_key
          end
        end
        @new_nodes = next_nodes
      end
    end
  end
end

short_path = ShortPath.new(input, 1, 3)
short_path.build_grid

res_1 =  short_path.grid.select { |k, _v| k[0] == short_path.size - 1 && k[1] == short_path.size - 1 }
                    .values
                    .min

puts "FIRST PART: #{res_1}"

short_path = ShortPath.new(input, 4, 10)
short_path.build_grid

res_2 =  short_path.grid.select { |k, v| k[0] == short_path.size - 1 && k[1] == short_path.size - 1 && k[3] >= 4 }
                        .values
                        .min


puts "SECOND PART: #{res_2}"