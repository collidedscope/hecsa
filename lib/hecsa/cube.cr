module Hecsa
  # Representation of a Rubik's Cube that uses Speffz notation for everything.
  class Cube
    SOLVED = "AaBbCcDd1EeFfGgHh2IiJjKkLl3MmNnOoPp4QqRrSsTt5UuVvWwXx6"

    property! relative : RelativeCube

    def initialize
      @state = SOLVED
      @relative = RelativeCube.new
    end

    def resolve(location : Char)
      @state[SOLVED.index(location).not_nil!]
    end

    def resolve(locations : String)
      locations.chars.map(&->resolve(Char)).join
    end

    def resolve_relative(locations)
      relative.unsolve resolve locations
    end

    def solved?(locations)
      locations == resolve_relative locations
    end

    def solved?
      @state == SOLVED
    end

    def exec1(move)
      @state = resolve MOVES[move.tr "'3", "_"]
      if rotation = ORIENTAL[move.tr "'", "_"]?
        relative.exec rotation
      end
    end

    def exec(moves)
      moves.split &->exec1(String)
      self
    end

    def face(facelet)
      SOLVED.index(facelet).not_nil! // 9
    end
  end

  class RelativeCube < Cube
    def initialize
      @state = SOLVED
    end

    def unsolve(location : Char)
      SOLVED[@state.index(location).not_nil!]
    end

    def unsolve(locations : String)
      locations.chars.map(&->unsolve(Char)).join
    end

    def exec1(move)
      @state = resolve MOVES[move.tr "'", "_"]
    end
  end
end

require "hecsa/cube/moves"
