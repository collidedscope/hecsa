require "hecsa"
require "hecsa/cube"
require "hecsa/solver"
require "hecsa/util"

module Hecsa
  class M2OPSolver < Solver
    getter cube : Cube

    EDGES = %w[aq bm ci de fl gx hr jp ku nt ov sw].map(&.chars).to_h

    def initialize(@scramble : String, @buffer = 'u')
      @cube = Cube.new.exec @scramble
    end

    def progress(moves)
      @cube.exec moves
    end

    def solution
      Util.consolidate @cube.history[@scramble.split.size..]
    end

    def solve
      m2
      op
    end

    def m2
    end

    def op
    end

    def flipped_edges
      EDGES.select { |k, v| v == @cube.resolve k }.keys
    end

    def show
      p solution
    end
  end
end
