module Hecsa::Util
  def self.consolidate(moves)
    counts = {'\'' => -1, '2' => 2, '3' => 3}

    moves
      .chunks { |c| c[0] == 'U' || c[0] == 'y' }
      .flat_map { |lost, seq|
        next seq if !lost || seq.size == 1
        seq.sort.reverse.group_by(&.[0]).map { |face, moves|
          degree = moves.sum { |move| counts[move[1]?]? || 1 } % 4
          "#{face}#{"  2'"[degree]}".rstrip if degree > 0
        }.compact
      }
  end

  def self.log(msg, kind = nil, io = STDERR)
    io.puts case kind
    when :success
      msg.colorize :green
    when :error
      msg.colorize :red
    else
      msg
    end
  end
end
