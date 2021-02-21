require "hecsa"

def best_cross(scramble)
  ["", "z", "z2", "z'", "x", "x'"].map { |rot|
    Hecsa::Solver.new("#{scramble} #{rot}").tap &.cross
  }.min_by &.solution.size
end

print "Scramble: "
scramble = gets

sln = best_cross scramble
sln.f2l
sln.show
