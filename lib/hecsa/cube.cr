module Hecsa
  # Representation of a Rubik's Cube that uses Speffz notation for everything.
  class Cube
    SOLVED = "AaBbCcDd1EeFfGgHh2IiJjKkLl3MmNnOoPp4QqRrSsTt5UuVvWwXx6"

    # Moves are represented as anagrams of the solved state. An x rotation, for
    # example, makes it so that whatever facelet was at location I is now at A.
    MOVES = {
      U: "DdAaBbCc1IiJfGgHh2MmNjKkLl3QqRnOoPp4EeFrSsTt5UuVvWwXx6",
      L: "SaBbCcRr1HhEeFfGg2AiJjKkDd3MmNnOoPp4QqXxUsTt5IuVvWwLl6",
      F: "AaBbFfGd1EeUuVgHh2LlIiJjKk3DmNnOoCc4QqRrSsTt5PpMvWwXx6",
      R: "AaJjKcDd1EeFfGgHh2IiVvWkLl3PpMmNnOo4CqRrSsBb5UuTtQwXx6",
      B: "NnObCcDd1BeFfGgAa2IiJjKkLl3MmWwXoPp4TtQqRrSs5UuVvHhEx6",
      D: "AaBbCcDd1EeFfSsTh2IiJjGgHl3MmNnKkLp4QqRrOoPt5XxUuVvWw6",
      u: "DdAaBbCc1IiJjGgHl3MmNnKkLp4QqRrOoPt5EeFfSsTh2UuVvWwXx6",
      l: "SsBbCqRr5HhEeFfGg2AaJjKcDd1MmNnOoPp4QwXxUuTt6IiVvWkLl3",
      f: "AaBeFfGg2ExUuVvHh6LlIiJjKk3DdNnObCc1QqRrSsTt5PpMmWwXo4",
      r: "AiJjKkDd3EeFfGgHh2IuVvWwLl6PpMmNnOo4CcRrSaBb1UsTtQqXx5",
      b: "NnOoCcDm4BbFfGdAa1IiJjKkLl3MvWwXxPp6TtQqRrSs5UuVgHhEe2",
      d: "AaBbCcDd1EeFrSsTt5IiJfGgHh2MmNjKkLl3QqRnOoPp4XxUuVvWw6",
      E: "AaBbCcDd1EeFrGgHt5IiJfKkLh2MmNjOoPl3QqRnSsTp4UuVvWwXx6",
      M: "AsBbCqDd5EeFfGgHh2IaJjKcLl1MmNnOoPp4QwRrSuTt6UiVvWkXx3",
      S: "AaBeCcDg2ExFfGvHh6IiJjKkLl3MdNnObPp1QqRrSsTt5UuVmWwXo4",
      x: "IiJjKkLl3FfGgHhEe2UuVvWwXx6PpMmNnOo4CcDdAaBb1SsTtQqRr5",
      y: "DdAaBbCc1IiJjKkLl3MmNnOoPp4QqRrSsTt5EeFfGgHh2VvWwXxUu6",
      z: "HhEeFfGg2XxUuVvWw6LlIiJjKk3DdAaBbCc1RrSsTtQq5PpMmNnOo4",
    }

    # moves which affect the orientation of the cube
    ORIENTAL = {
      x: "x", y: "y", z: "z", E: "y'", M: "x'", S: "z",
      u: "y", l: "x'", f: "z", r: "x", b: "z'", d: "y'",
    }

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
      @state = resolve MOVES[move]
      if rotation = ORIENTAL[move]?
        relative.exec rotation
      end
    end

    def exec(moves)
      moves
        .gsub("2'", '2').tr("'", "3")
        .gsub(/(\w)(\d)/) { "#{$1} " * $2.to_i }
        .split &->exec1(String)

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
      @state = resolve MOVES[move]
    end
  end
end
