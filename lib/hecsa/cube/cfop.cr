class Hecsa::Cube
  # returns the number of D moves away from solved the cross is
  def cross_solved?
    %w[uvwx vwxu wxuv xuvw].index resolve_relative("uvwx")
  end

  def f2l_pairs
    %w[Ul Vj Wt Xr].count &->solved?(String)
  end
end
