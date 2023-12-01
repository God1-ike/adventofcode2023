sum = 0

# first part
File.readlines('1.txt').each do |line|
  values = line.strip.scan(/\d/).flatten

  first_number = values.first
  last_number = values.last

  sum += [first_number, last_number].join.to_i
end

puts "FIRST PART: #{sum}"


# second part

VAL_MAP = {
  'one' => 1,
  '1' => 1,
  'two' => 2,
  '2' => 2,
  'three' => 3,
  '3' => 3,
  'four' => 4,
  '4' => 4,
  'five' => 5,
  '5' => 5,
  'six' => 6,
  '6' => 6,
  'seven' => 7,
  '7' => 7,
  'eight' => 8,
  '8' => 8,
  'nine' => 9,
  '9' => 9
}

sum = 0
File.readlines('1.txt').each do |line|
  word_nubmers = 'one|two|three|four|five|six|seven|eight|nine'
  first_spelled_digit = line.strip.scan(/(#{word_nubmers}|\d)/).flatten.first

  reverse_line = line.reverse

  last_spelled_digit = reverse_line.strip.scan(/(#{word_nubmers.reverse}|\d)/).flatten.first

  first_number = VAL_MAP[first_spelled_digit]
  last_number = VAL_MAP[last_spelled_digit.reverse]

  sum += [first_number, last_number].join.to_i
end

puts "SECOND PART: #{sum}"
