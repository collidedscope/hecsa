require "colorize"
require "hecsa/cube"
require "hecsa/cube/cfop"
require "hecsa/cube/draw"

module Hecsa
  class Solver
    property cube : Cube
    getter solution

    EDGES = 'a'..'x'
    SLOTS = {"Ul" => "L' U' L", "Vj" => "R U R'",
             "Wt" => "R' U R", "Xr" => "L U' L'"}

    def initialize(scramble)
      @cube = Cube.new.exec scramble
      @solution = [] of String
      @misalignment = 0

      Solver.log "Scramble: #{scramble}"
    end

    def progress(moves)
      @solution << moves
      @cube.exec moves
    end

    def cfop
      cross
      Solver.log "solved cross", :success
      @cube.draw

      f2l
      Solver.log "solved F2L", :success
      @cube.draw
    end

    def cross
      @misalignment = inspect

      until offset = @cube.cross_solved?
        try_cross
      end

      return if offset.zero?

      progress %w[D D2 D'][offset - 1].not_nil!
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

      abort "stuck on cross" if options.empty?

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

        _, alg = SLOTS.find { |slot, _| slot != @cube.resolve_relative slot }.not_nil!
        progress alg
      end
    end

    def try_f2l
      Hecsa.f2l_knowledge.each do |from, algs|
        algs.each do |to, alg|
          next unless to == @cube.resolve_relative from

          Solver.log "solving #{from} into #{to} (#{alg})"
          return progress alg
        end
      end

      nil
    end

    def show
      p @solution
      @cube.draw
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
end
