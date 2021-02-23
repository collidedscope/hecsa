require "hecsa/solver"

module Hecsa
  alias Algs = Hash(String, String)

  class_getter cross_knowledge = {} of String => Algs
  class_getter f2l_knowledge = {} of String => Algs

  def self.teach_cross(from, to, alg)
    (cross_knowledge[from] ||= Algs.new)[to] = alg
  end

  def self.teach_f2l(from, to, alg)
    (f2l_knowledge[from] ||= Algs.new)[to] = alg
  end
end

require "hecsa/knowledge/cross"
require "hecsa/knowledge/f2l"
