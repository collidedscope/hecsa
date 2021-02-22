class Hecsa::Cube
  ART    = File.read File.expand_path "../../../data/art", __DIR__
  UFR    = "AaBbCcDd1IiJjKkLl3MmNnOoPp4"
  COLORS = [255, 208, 40, 196, 21, 226]

  def draw(io = STDOUT)
    map = {" " => " "}

    UFR.each_char do |c|
      color = COLORS[SOLVED.index(resolve(c.to_s)).not_nil! // 9]
      map[c.to_s] = "\e[48;5;#{color}m \e[0m"
    end

    io.puts ART.gsub /./, map
  end
end
