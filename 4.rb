class CardsParser
  class Card
    attr_accessor :id, :name, :win_numbers, :numbers, :matched_numbers

    def initialize(name, win_numbers, numbers)
      @name = name
      @win_numbers = win_numbers
      @numbers = numbers
      @matched_numbers = prepare_matched_numbers
    end

    def points
      return 0 if @matched_numbers.empty?

      2.pow(@matched_numbers.count - 1)
    end

    def id
      name.split(' ').last.to_i
    end

    private

    def prepare_matched_numbers
      @numbers.intersection(@win_numbers)
    end
  end

  attr_accessor :cards

  def initialize(file_path)
    @file_path = file_path
    @cards = []
  end

  def parse
    File.readlines(@file_path).each do |line|
      card_name, numbers = line.strip.split(': ')
      win_numbers, numbers = numbers.split(' | ')

      @cards << Card.new(card_name,
                         win_numbers.split(' ').map(&:to_i),
                         numbers.split(' ').map(&:to_i)
                        )

    end
  end
end



parser = CardsParser.new('4_input.txt')
parser.parse

# first part

puts "FIRST PART: #{parser.cards.map(&:points).sum}"

# second part


@max_cars_count = parser.cards.count


# медленное, но можно сделать нормальную рекурсию, которая ускорит или упростить каунтер
def copy_cards(card, cards, copied_cards = [])
  return [] if card.nil? || card.id == @max_cars_count
  return [] if card.matched_numbers.count.zero?

  matched_count = card.matched_numbers.count

  card_index = card.id

  cloned = cards.select { |c| ((card_index + 1)..(card_index + matched_count)).to_a.include?(c.id) }
  copied_cards << cloned

  cloned.each do |clone_card|
    copied_cards << copy_cards(clone_card, cards)
  end

  copied_cards
end

result_2 = parser.cards
                 .map do |card| 
                  p card.name
                  copy_cards(card, parser.cards)
                 end
                 .flatten
                 .map(&:name)
                 .count
# tmp = parser.cards.first

# result_2 = copy_cards(tmp, parser.cards).flatten.map { |e| e.name }

puts "SECOND PART: #{result_2 + @max_cars_count}"
