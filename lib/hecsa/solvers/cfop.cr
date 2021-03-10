require "hecsa"
require "hecsa/cube"
require "hecsa/cube/cfop"
require "hecsa/cube/draw"
require "hecsa/knowledge/cross"
require "hecsa/knowledge/f2l"
require "hecsa/knowledge/oll"
require "hecsa/knowledge/pll"
require "hecsa/solver"
require "hecsa/util"

module Hecsa
  class CFOPSolver < Solver
    getter cube : Cube

    EDGES = 'a'..'x'
    FACES = %w[white orange green red blue yellow]
    SLOTS = {"Ul" => "L' U_ L", "Vj" => "R U_ R'",
             "Wt" => "R' U_ R", "Xr" => "L U_ L'"}
    PLL_NAMES = %w[Aa Ab E F Ga Gb Gc Gd H Ja Jb Na Nb Ra Rb T Ua Ub V Y Z]

    def initialize(@scramble : String)
      @cube = Cube.new.exec @scramble
      @misalignment = 0
    end

    def progress(moves)
      @cube.exec moves
    end

    def solution
      Util.consolidate @cube.history[@scramble.split.size..]
    end

    def solve
      cross
      f2l
      oll
      pll
    end

    def cross
      @misalignment = inspect

      until offset = @cube.cross_solved?
        try_cross
      end

      progress %w[\  D D2 D'][offset]
    end

    def misalign(edge)
      'u' + (edge - 'u' + @misalignment) % 4
    end

    def inspect
      cross_pieces = @cube.resolve_relative "uvwx"
      solved = cross_pieces.chars.zip("uvwx".chars)
        .select { |piece, loc| "uvwx"[piece]? }

      # Find the "most solved" edge to use as our anchor.
      solved.map { |a, b| b - a }.min? || 0
    end

    def try_cross
      options = unsolved_edges.map { |a, b|
        Hecsa.cross_knowledge[a][b].as String
      }

      # TODO: Determine best edge to solve.
      progress options.sample
    end

    def unsolved_edges
      EDGES.map { |edge|
        if "uvwx"[home = @cube.resolve_relative edge]?
          home = misalign home
          {edge.to_s, home.to_s} if edge != home
        end
      }.compact
    end

    def f2l
      until @cube.f2l_pairs == 4
        next if try_f2l || (%w[U U U y] * 4).find do |seek|
                  progress seek
                  try_f2l
                end

        # If we get here, no combination of angle and AUF results in finding
        # the pieces of a pair that we know how to solve. This is usually due
        # to pieces being mis-slotted and/or misoriented, so we just break
        # up a random unsolved pair randomly and try again. Doing this without
        # changing the orientation can lead to stuckage, so we rotate first.

        progress %w[y y'].sample
        _, alg = SLOTS.reject(->@cube.solved?(String)).sample
        progress alg.tr "_", ["", "2", "'"].sample
      end
    end

    def try_f2l
      options = [] of String

      Hecsa.f2l_knowledge.each do |from, algs|
        algs.each do |to, alg|
          options << alg if to == @cube.resolve_relative from
        end
      end

      progress options.min_by &.count ' ' unless options.empty?
    end

    def oll
      id, auf = @cube.oll_case.not_nil!

      progress %w[\  U U2 U'][auf]
      progress Hecsa.oll_knowledge[id]
    end

    def pll
      id, auf = @cube.pll_case.not_nil!

      progress %w[\  U U2 U'][auf]
      progress Hecsa.pll_knowledge[id]
      progress %w[\  U U2 U'][auf] if auf = @cube.auf
    end

    def take_moves_until(moves)
      taken = [] of String
      while move = moves.shift
        taken << move
        break if yield move
      end
      taken
    end

    def show
      fresh = Cube.new.exec @scramble
      fresh.draw_mini
      moves = solution

      insp = moves.shift moves.index { |m| !"xyz"[m[0]]? }.not_nil!
      fresh.exec insp
      puts "#{insp.join ' '} // inspection"

      cross = fresh.resolve('6').to_i - 1
      puts take_moves_until(moves) { |m|
        fresh.exec1 m
        fresh.cross_solved? == 0
      }.join(' ') + " // #{FACES[cross]} cross"

      4.times do |i|
        puts take_moves_until(moves) { |m|
          fresh.exec1 m
          fresh.cross_solved? && fresh.f2l_pairs > i
        }.join(' ') + " // F2L #{i + 1}"
      end

      oll = fresh.oll_case.not_nil![0]
      puts take_moves_until(moves) { |m|
        fresh.exec1 m
        fresh.f2l_pairs == 4 && fresh.pll_case
      }.join(' ') + " // OLL #{oll}"

      pll = fresh.pll_case.not_nil![0]
      puts moves.join(' ') + " // #{PLL_NAMES[pll - 1]}-perm"
    end
  end
end
