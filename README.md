# Husler [![Build Status](https://secure.travis-ci.org/soulcutter/husler.png)](http://travis-ci.org/soulcutter/husler)

A ruby implementation of [HUSL, a human-friendly color space](http://boronine.com/husl/).

## Usage

```ruby
Husler.rgb_to_husl(r, g, b) # rgb values must be between 0 and 1

Husler.husl_to_rgb(h, s, l) # h(ue) is between 0-360 and s(aturation) and l(ightness) between 0-100
```

## Credit

Algorithms translated from Alexei Boronine's canonical implementation at https://github.com/boronine/husl