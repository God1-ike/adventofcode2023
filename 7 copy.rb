# first part

class Table
  attr_accessor :hands

  def initialize(joker:)
    @joker = joker
    @hands = parse_hands
  end

  def parse_hands
    File.read('7_input.txt')
            .split("\n")
            .map do |s| 
             cards, bid = s.split(' ')
             { cards: cards, bid: bid.to_i, hand_type: hand_type(cards), hand_points: hand_points(cards) }
            end
  end

  def card_point(card)
    case card
    when 'A'
      14
    when 'K'
      13
    when 'Q'
      12
    when 'J'
      @joker ? 1 : 11
    when 'T'
      10
    else
      card.to_i
    end
  end

  def hand_type(hand)
    hand_info = hand.each_char.tally

    if @joker && jokers = hand_info.delete('J')
      up_key = hand_info.sort_by { |e| [e.last, card_point(e.first)]}&.last&.first || 'J'
      hand_info[up_key] = hand_info[up_key].to_i + jokers.to_i
    end

    case hand_info.size
    when 1
      7
    when 2
      hand_info.values.any?(4) ? 6 : 5
    when 3
      hand_info.values.any?(3) ? 4 : 3
    when 4
      2
    else
      1
    end
  end

  def hand_points(hand)
    hand.each_char.map { |card| card_point(card).chr }.join
  end
end


table = Table.new(joker: false)

hands = table.hands.sort_by { |h| [h[:hand_type], h[:hand_points]] }
             .map.with_index {|h, i| h.merge(rank: i + 1)}


puts "FIRST PART: #{hands.reduce(0) { |sum, h| sum + (h[:bid] * h[:rank]) }}"

# # second part

table = Table.new(joker: true)

hands = table.hands.sort_by { |h| [h[:hand_type], h[:hand_points]] }
             .map.with_index {|h, i| h.merge(rank: i + 1)}


puts "SECOND PART: #{hands.reduce(0) { |sum, h| sum + (h[:bid] * h[:rank]) }}"
