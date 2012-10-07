require 'mathn'

require "husler/version"
require 'husler/constants'

# :nodoc:
module Husler
  extend self

  #	Pass in HUSL values and get back RGB values, H ranges from 0 to 360, S and L from 0 to 100.
  #	RGB values will range from 0 to 1.
  def husl_to_rgb(h, s, l)
    raise ArgumentError.new("h value (#{h}) must be in the range 0..360") unless (0..360).include? h
    raise ArgumentError.new("s value (#{s}) must be in the range 0..100") unless (0..100).include? s
    raise ArgumentError.new("l value (#{l}) must be in the range 0..100") unless (0..100).include? l

    xyz_rgb(luv_xyz(lch_luv(husl_lch([h, s, l]))))
  end

  #	Pass in RGB values ranging from 0 to 1 and get back HUSL values.
  #	H ranges from 0 to 360, S and L from 0 to 100.
  def rgb_to_husl(r, g, b)
    rgb = [r, g, b]
    raise ArgumentError.new("rgb values (#{r}, #{g}, #{b}) must all be in the range 0..1") if rgb.any? { |v| !(0..1).include? v }
    lch_husl(luv_lch(xyz_luv(rgb_xyz(rgb))))
  end

  private

  def max_chroma(l, h)
    hrad = (h / 360.0) * 2.0 * PI
    sin_h = Math.sin(hrad)
    cos_h = Math.cos(hrad)
    sub1 = ((l + 16) ** 3) / 1560896.0
    sub2 = sub1 > 0.008856 ? sub1 : (l / 903.3);

    result = Float::INFINITY

    M.each do |m1, m2, m3|
      top = ((0.99915 * m1 + 1.05122 * m2 + 1.14460 * m3) * sub2);
      rbottom = (0.86330 * m3 - 0.17266 * m2);
      lbottom = (0.12949 * m3 - 0.38848 * m1);
      bottom = (rbottom * sin_h + lbottom * cos_h) * sub2;

      LIMITS.each do |t|
        c = (l * (top - 1.05122 * t) / (bottom + 0.17266 * sin_h * t));
        result = c if c > 0 && c < result
      end
    end

    result
  end

  def dot_product l1, l2
    sum = 0
    for i in 0...l1.size
      sum += l1[i] * l2[i]
    end
    sum
  end

  def f(t)
    t > LAB_E ? (t ** ONE_THIRD) : (7.787 * t + 16 / 116.0)
  end

  def f_inv(t)
    val = t ** 3
    val > LAB_E ? val : ((116 * t - 16) / LAB_K)
  end

  def from_linear(c)
    c <= 0.0031308 ? (12.92 * c) : (1.055 * (c ** (1 / 2.4)) - 0.055)
  end

  def to_linear(c)
    a = 0.055

    c > 0.04045 ? ( ((c + a) / (1 + a)) ** 2.4) : (c / 12.92)
  end

  def rgb_prepare(tuple)
    tuple.map! do |v|
      v = v.round(3)
      v = [0, v].max
      v = [1, v].min

      (v * 255).round
    end
  end

  def xyz_rgb(tuple)
    (0...3).each do |i|
      tuple[i] = from_linear(dot_product(M[i], tuple))
    end
    tuple
  end

  def rgb_xyz(tuple)
    rgbl = tuple.map { |v| to_linear(v) }

    (0...3).each do |i|
      tuple[i] = dot_product(M_INV[i], rgbl)
    end
    tuple
  end

  def xyz_luv(tuple)
    x, y, z = *tuple

    var_u = (4 * x) / (x + (15.0 * y) + (3 * z));
    var_v = (9 * y) / (x + (15.0 * y) + (3 * z));

    l = 116 * f(y / REF_Y) - 16;
    u = 13 * l * (var_u - REF_U);
    v = 13 * l * (var_v - REF_V);

    tuple[0], tuple[1], tuple[2] = l, u, v

    tuple
  end

  def luv_xyz(tuple)
    l, u, v = *tuple

    return tuple.map! { 0.0 } if l == 0

    var_y = f_inv((l + 16) / 116.0)
    var_u = u / (13.0 * l) + REF_U
    var_v = v / (13.0 * l) + REF_V

    y = var_y * REF_Y
    x = 0 - (9 * y * var_u) / ((var_u - 4.0) * var_v - var_u * var_v)
    z = (9 * y - (15 * var_v * y) - (var_v * x)) / (3.0 * var_v)

    tuple[0], tuple[1], tuple[2] = x, y, z

    tuple
  end

  def luv_lch(tuple)
    _, u, v = *tuple

    c = ((u ** 2) + (v ** 2)) ** (1 / 2.0)
    h_rad = Math.atan2(v, u)
    h = h_rad * 360.0 / 2.0 / PI
    h = h + 360 if h < 0

    tuple[1], tuple[2] = c, h

    tuple
  end

  def lch_luv(tuple)
    _, c, h = *tuple

    h_rad = h / 360.0 * 2.0 * PI
    u = Math.cos(h_rad) * c
    v = Math.sin(h_rad) * c

    tuple[1] = u
    tuple[2] = v

    tuple
  end

  def husl_lch(tuple)
    h, s, l = *tuple

    max = max_chroma(l, h)
    c = max / 100.0 * s

    tuple[0], tuple[1], tuple[2] = l, c, h
    tuple
  end

  def lch_husl(tuple)
    l, c, h = *tuple

    max = max_chroma(l, h)
    s = c / max * 100

    tuple[0], tuple[1], tuple[2] = h, s, l
    tuple
  end
end
