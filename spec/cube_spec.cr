require "./spec_helper"
require "hecsa/cube"

NOOP = <<-ALG
x x' y y' z z'
F F' F2 B B' B2 R R' R2 L L' L2 U U' U2 D D' D2
f f' f2 b b' b2 r r' r2 l l' l2 u u' u2 d d' d2
M2 S2 E2 M z2 M' S y2 S' E x2 E'
ALG

describe Hecsa do
  it "should correctly execute the comprehensive no-op sequence" do
    Hecsa::Cube.new.exec(NOOP).solved?.should be_true
  end
end
