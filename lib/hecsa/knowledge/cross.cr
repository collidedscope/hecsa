require "yaml"

algs = File.expand_path "../../../data/algs/cross.yaml", __DIR__

YAML.parse(File.open(algs)).as_h.each do |edge, homes|
  homes.as_h.each do |home, alg|
    Hecsa.teach_cross edge.as_s, home.as_s, alg.as_s
  end
end
