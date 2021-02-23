require "yaml"

f2l = File.expand_path "../../../data/algs/F2L.yaml", __DIR__

YAML.parse(File.open f2l).as_h.each do |pair, algs|
  algs.as_h.each do |slot, alg|
    Hecsa.teach_f2l pair.as_s, slot.as_s, alg.as_s
  end
end
