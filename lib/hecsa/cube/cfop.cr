require "./cfop/ids"

class Hecsa::Cube
  OLL_FACELETS = "AaBbCcDd1IiJMmN"
  PLL_FACELETS = "eFIiJ"
  OPPOSITES    = {0 => 5, 1 => 3, 2 => 4, 3 => 1, 4 => 2, 5 => 0}

  # returns the number of D moves away from solved the cross is
  def cross_solved?
    %w[uvwx vwxu wxuv xuvw].index resolve_relative("uvwx")
  end

  def f2l_pairs
    %w[Ul Vj Wt Xr].count &->solved?(String)
  end

  def oll_case
    id = 0u16

    OLL_FACELETS.each_char do |facelet|
      id <<= 1
      id += 1 if face(resolve_relative facelet) == 0
    end

    OLL_IDS.index(id).not_nil!.divmod 4
  end

  # TODO: Clean this up a lot.
  def pll_case
    id = 0u16
    adj = nil
    anchor = face resolve 'E'

    PLL_FACELETS.each_char do |facelet|
      color = face resolve facelet
      id <<= 2
      if OPPOSITES[anchor] == color
        id += 2
      elsif anchor != color
        if adj
          id += color == adj ? 1 : 3
        else
          id += 1
          adj = color
        end
      end
    end

    PLL_IDS.index(id).not_nil!.divmod 4
  end

  def auf
    %w[abcd bcda cdab dabc].index resolve_relative("abcd")
  end
end
