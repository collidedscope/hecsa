require "hecsa/solvers/cfop"

def shortest_solution(scramble)
  cross = %w[\  z z2 z' x x'].product %w[\  y y2 y']
  f2l = %w[\  y y2 y'].product %w[\  U U2 U']

  cross.product(f2l).map { |cross, f2l|
    Hecsa::CFOPSolver.new(scramble).tap { |s|
      s.progress cross.join ' '
      s.cross
      s.progress f2l.join ' '
      s.f2l
      s.oll
      s.pll
    }
  }.min_by &.solution.size
end

print "Scramble: "
if scramble = gets
  shortest_solution(scramble).show
end
