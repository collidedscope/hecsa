module Hecsa
  alias Algs = Hash(String, String)

  class_getter cross_knowledge = {} of String => Algs
  class_getter f2l_knowledge = {} of String => Algs
  class_getter m2_knowledge = {} of String => Algs
  class_property oll_knowledge = [] of String
  class_property pll_knowledge = [] of String

  def self.teach_cross(from, to, alg)
    (cross_knowledge[from] ||= Algs.new)[to] = alg
  end

  def self.teach_f2l(from, to, alg)
    (f2l_knowledge[from] ||= Algs.new)[to] = alg
  end

  def self.teach_m2(from, to, alg)
    (m2_knowledge[from] ||= Algs.new)[to] = alg
  end
end
