require "hecsa"

def best_cross(scramble)
  %w[\  z z2 z' x x'].product(%w[\  y y2 y']).map { |rot|
    Hecsa::Solver.new(scramble).tap { |s|
      s.progress rot.join ' '
      s.cross
    }
  }.min_by &.solution.size
end

print "Scramble: "
if scramble = gets
  sln = best_cross scramble
  sln.f2l
  sln.oll
  sln.pll
  sln.show
end
