require "yaml"

oll = File.expand_path "../../../data/algs/OLL", __DIR__

Hecsa.oll_knowledge = File.read_lines oll
