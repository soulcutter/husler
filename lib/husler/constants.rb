module Husler
  PI = Math::PI
  #PI = 3.1415926535897932384626433832795
  INFINITY = +1.0/0 # positive infinity technically

  ONE_THIRD = (1.0 / 3.0)

  M = [
    [3.2406, -1.5372, -0.4986],
    [-0.9689, 1.8758, 0.0415],
    [0.0557, -0.2040, 1.0570]
  ]

  M_INV = [
    [0.4124, 0.3576, 0.1805],
    [0.2126, 0.7152, 0.0722],
    [0.0193, 0.1192, 0.9505]
  ]

  LIMITS = [0.0, 1.0]

  REF_X = 0.95047
  REF_Y = 1.00000
  REF_Z = 1.08883

  REF_U = 0.19784
  REF_V = 0.46834
  
  LAB_E = 0.008856
  LAB_K = 903.3
end