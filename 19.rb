@res_logic = {}
parse_input_step = :logic
parse_input = {}
File.read('19_input.txt')
    .split("\n")
    .map(&:strip)
    .each do |row| 
      next parse_input_step = :data if row.empty?

      if parse_input_step == :logic
        name, logics = row.split('{')

        logics = logics.gsub(/}/, '')
                       .split(',')
                       .map do |diff_logic|
                        caps = diff_logic.match(/(\w)(\>|\<)(\d+):([A-Za-z]+)/)
                        if caps
                          ret = caps.captures
                          ret[1] = ret[1]&.to_sym
                          ret[2] = ret[2]&.to_i

                          ret.compact
                        else
                          [diff_logic]
                        end
                       end

        @res_logic[name] = logics
      else
        key = row.gsub(/[{|}]/, '')
                 .split(',')
                 .map { |e| e.split('=') }
        parse_input[key.to_h] = nil
      end
    end


def find_part_way(rating)
  way = ['in']
  while (way.last != 'R' || way.last != 'A')
    break if way.last == 'R' || way.last == 'A'

    current_logc = @res_logic[way.last]
    current_logc.each do |lo|
      break way << lo.last if lo.size == 1
      break way << lo.last if rating[lo[0]].to_i.send(lo[1], lo[2])
    end
  end

  way
end


parse_input.keys.each do |k|
  parse_input[k] = find_part_way(k)
end


res_1 = parse_input.select { |k, v| v.last == 'A'}
                    .keys
                    .map { |d| d.values.map(&:to_i).sum }
                    .sum
puts "FIRST PART: #{ res_1 }"


input = File.read('19_input.txt')
            .split("\n\n")
            .map(&:split)

logics = input.first.map do |val|
  index_strat = val.index('{')
  logic = val[index_strat + 1... val.size - 1].split(',').map { |r|
    caps = r.match(/(\w)(\>|\<)(\d+):([A-Za-z]+)/)
    if caps
      ret = caps.captures
      ret[1] = ret[1] == '>' ? 0 : -1
      ret[2] = ret[2].to_i
      ret
    else
      r
    end
  }
  [val[0, index_strat], logic]
end.to_h

queue = [{
  'curr_logic' => 'in',
  'x' => (1..4000), 'm' => (1..4000),
  'a' => (1..4000), 's' => (1..4000)
}]

accepted = []
while part = queue.pop
  curr_logic = part['curr_logic']
  accepted << part.slice('x', 'm', 'a', 's') if curr_logic == 'A'

  next unless logics.key?(curr_logic)

  logics[curr_logic].each do |r|
    if r.is_a?(Array)
      prop, cutd, val, goto = r

      cuti = val + cutd
      split_rng, cont_rng = (part[prop].begin..cuti), (cuti+1..part[prop].end)
      split_rng, cont_rng = cont_rng, split_rng if cutd == 0

      part[prop] = cont_rng

      split_part = part.clone
      split_part['curr_logic'] = goto
      split_part[prop] = split_rng
      queue.unshift(split_part)
    else
      part['curr_logic'] = r
      queue.unshift(part)
    end
  end
end

res_2 = accepted.sum { |a| a.values.map(&:size).reduce(&:*) }
puts "SECOND PART: #{ res_2 }"
