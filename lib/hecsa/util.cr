require "colorize"

module Hecsa::Util
  extend self

  def invert(moves)
    moves.split.reverse.map { |move|
      counts = {'\'' => 3, '2' => 2, '3' => 3}
      degree = 4 - (counts[move[1]?]? || 1)
      "#{move[0]}#{"  2'"[degree]}".rstrip
    }
  end

  def expand(moves)
    moves.gsub(/\[(.+?)\s*(:|,)\s*(.+?)\]/) {
      "#{$1} #{$3} #{invert($1).join ' '} #{invert($3).join ' ' if $2 == ","}"
    }.gsub(/\((.+?)\)(\d+)/) { "#{$1} " * $2.to_i }
  end

  def consolidate(moves)
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

  def log(msg, kind = nil, io = STDERR)
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
