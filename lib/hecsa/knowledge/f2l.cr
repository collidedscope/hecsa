require "yaml"

vj = File.expand_path "../../../data/algs/Vj.yaml", __DIR__

YAML.parse(File.open vj).as_h.each do |pair, alg|
  Hecsa.teach_f2l pair.as_s, "Vj", alg.as_s
end

f2l = File.expand_path "../../../data/algs/F2L.yaml", __DIR__

YAML.parse(File.open f2l).as_h.each do |pair, algs|
  algs.as_h.each do |slot, alg|
    Hecsa.teach_f2l pair.as_s, slot.as_s, alg.as_s
  end
end
