require "hecsa/cube"
require "hecsa/cube/cfop"
require "hecsa/cube/draw"

module Hecsa
  class Solver
    property cube : Cube
    property :solution

    EDGES = ("a".."x")
    SLOTS = {"Ul" => "L' U' L", "Vj" => "R U R'",
             "Wt" => "R' U R", "Xr" => "L U' L'"}

    def initialize(scramble)
      @cube = Cube.new.exec scramble
      @solution = [] of String
    end

    def progress(moves)
      @solution << moves
      @cube.exec moves
    end

    def cfop
      cross
      f2l
    end

    def cross
      until offset = @cube.cross_solved?
        try_cross
      end

      return if offset.zero?

      progress %w[D D2 D'][offset - 1].not_nil!
    end

    def try_cross
      options = unsolved_edges.map { |a, b|
        Hecsa.cross_knowledge[a][b].as String
      }

      if options.empty? || options.uniq.size != options.size
        # TODO: Handle awkward cases more deterministically.
        progress %w[F F2 F' B B2 B' R R2 R' L L2 L'].sample
      else
        progress options.sample
      end
    end

    def unsolved_edges
      # TODO: Get bad edges out of the bottom layer before starting.
      bad = {"k" => "u", "o" => "v", "s" => "w", "g" => "x"}

      EDGES.map { |edge|
        home = @cube.resolve_relative edge
        {edge, home} if edge != home && "uvwx"[home]? && home != bad[edge]?
      }.compact
    end

    def f2l
      until @cube.f2l_pairs == 4
        next if try_f2l || (%w[U U U y] * 4).find do |seek|
                  progress seek
                  try_f2l
                end

        _, alg = SLOTS.find { |slot, _| slot != @cube.resolve_relative slot }.not_nil!
        progress alg
      end
    end

    def try_f2l
      Hecsa.f2l_knowledge.each do |from, (to, solution)|
        next unless to == @cube.resolve_relative from
        return progress solution
      end

      nil
    end

    def show
      p @solution
      @cube.draw
    end
  end
end
