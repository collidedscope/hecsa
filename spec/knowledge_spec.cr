require "./spec_helper"
require "hecsa/cube"
require "hecsa/cube/cfop"
require "hecsa/knowledge/*"

describe Hecsa do
  c = Hecsa::Cube.new

  it "should solve cross pieces" do
    Hecsa.cross_knowledge.each do |from, algs|
      algs.each do |to, alg|
        c.exec(alg) { c.resolve(to).should eq from }
      end
    end
  end

  it "should solve F2L pairs" do
    Hecsa.f2l_knowledge.each do |from, algs|
      algs.each do |to, alg|
        c.exec(alg) { c.resolve(to).should eq from }
      end
    end
  end

  it "should solve OLL cases" do
    Hecsa.oll_knowledge.each_with_index do |alg, i|
      c.undo alg
      c.oll_case.not_nil![0].should eq i
      c.exec alg
    end
  end

  it "should solve PLL cases" do
    Hecsa.pll_knowledge.each_with_index do |alg, i|
      c.undo alg
      c.pll_case.not_nil![0].should eq i
      c.exec alg
    end
  end
end
