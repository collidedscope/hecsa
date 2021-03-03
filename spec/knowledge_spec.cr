require "./spec_helper"
require "hecsa/cube"
require "hecsa/knowledge/*"

describe Hecsa do
  it "should solve cross pieces" do
    Hecsa.cross_knowledge.each do |from, algs|
      algs.each do |to, alg|
        Hecsa::Cube.new.exec(alg).resolve(to).should eq from
      end
    end
  end

  it "should solve F2L pairs" do
    Hecsa.f2l_knowledge.each do |from, algs|
      algs.each do |to, alg|
        Hecsa::Cube.new.exec(alg).resolve(to).should eq from
      end
    end
  end
end
