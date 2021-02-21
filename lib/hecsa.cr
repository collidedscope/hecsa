require "hecsa/solver"

module Hecsa
  alias CrossAlgs = Hash(String, String)

  class_property cross_knowledge = {} of String => CrossAlgs
  class_property f2l_knowledge = {} of String => {String, String}

  def self.teach_cross(from, to, alg)
    (cross_knowledge[from] ||= CrossAlgs.new)[to] = alg
  end

  def self.teach_f2l(from, to, alg)
    f2l_knowledge[from] = {to, alg}
  end
end

require "hecsa/knowledge/cross"
require "hecsa/knowledge/f2l"
