class Hecsa::Cube
  ART    = File.expand_path "../../../data/art", __DIR__
  MINI   = File.expand_path "../../../data/mini", __DIR__
  UFR    = "AaBbCcDd1IiJjKkLl3MmNnOoPp4"
  COLORS = [255, 208, 40, 196, 21, 226]

  def draw(io = STDOUT)
    map = {" " => " "}

    UFR.each_char do |c|
      color = COLORS[face resolve c]
      map[c.to_s] = "\e[48;5;#{color}m \e[0m"
    end

    io.puts File.read(ART).gsub /./, map
  end

  def draw_mini(io = STDOUT)
    rows = [] of Array(Int32)

    File.each_line(MINI) do |line|
      rows << line.chars.map { |c|
        c == ' ' ? 0 : COLORS[face resolve c]
      }
    end

    rows.each_slice 2 do |(top, bot)|
      io.puts String.build { |str|
        top.zip(bot) { |t, b| str << render_pair t, b }
      }
    end
  end
end

private def render_pair(t, b)
  case {t, b}
  when {0, 0}
    ' '
  when {_, 0}
    "\e[38;5;%dm▀\e[m" % t
  when {0, _}
    "\e[38;5;%dm▄\e[m" % b
  else
    "\e[48;5;%d#{t == b ? "m " : ";38;5;%dm▀" % t}\e[m" % b
  end
end
