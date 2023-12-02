def prepare_data(max_counts)
  data = []
  File.readlines('2_input.txt').each do |line|
    game_number, steps = line.strip.split(': ')

    _, id = game_number.split(' ')

    prepared_steps = steps.split('; ')
                          .map do |steps_arr| 
                            steps_arr.split(', ')
                                     .map { |e| e.split(' ').reverse }
                                     .to_h
                                     .transform_values(&:to_i)
                          end
    data << {
      id: id.to_i,
      steps: prepared_steps,
      valid: prepared_steps.none? do |steps|
        steps.any? { |k, v| v > max_counts[k] }
      end
    }
  end

  data
end

valid_max_counts = {
  'red' => 12,
  'green' => 13,
  'blue' => 14
}

data = prepare_data(valid_max_counts)

# first part
result_1 = data.select { |d| d[:valid] }
               .sum { |d| d[:id]}

puts "FIRST PART: #{result_1}"


# second part


result_2 = data.map do |d|
            [d[:steps].map { |h| h['red'] }.compact.max,
              d[:steps].map { |h| h['green'] }.compact.max,
              d[:steps].map { |h| h['blue'] }.compact.max
            ].reduce(&:*)
          end.sum

puts "SECOND PART: #{result_2}"
