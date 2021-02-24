require "yaml"

pll = File.expand_path "../../../data/algs/PLL", __DIR__

Hecsa.pll_knowledge = File.read(pll).split '\n'
