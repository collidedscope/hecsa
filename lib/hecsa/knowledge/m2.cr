require "yaml"

algs = File.expand_path "../../../data/algs/M2.yaml", __DIR__

YAML.parse(File.open(algs)).as_h.each do |home, edges|
  edges.as_h.each do |edge, alg|
    Hecsa.teach_m2 edge.as_s, home.as_s, alg.as_s
  end
end
