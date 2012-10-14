require 'spec_helper'

describe Husler do
  let(:deviation) { 1.0e-13 }

  context "#rgb_to_husl" do
    it "matches the expected output from the canonical coffeescript implementation" do
      # jQuery.husl.fromRGB(0.75, 0.5, 0.25);
      husl = Husler.rgb_to_husl(0.75, 0.5, 0.25)

      husl[0].should be_within(deviation).of(41.92580295066964)
      husl[1].should be_within(deviation).of(78.60025347503503)
      husl[2].should be_within(deviation).of(58.774191389329374)
    end
  end

  context "#husl_to_rgb" do
    it "matches the expected output from the canonical coffeescript implementation" do
      # jQuery.husl.toRGB(41.92580295066964, 78.60025347503503, 58.774191389329374)
      rgb = Husler.husl_to_rgb(41.92580295066964, 78.60025347503503, 58.774191389329374)

      rgb[0].should be_within(deviation).of(0.7499979858220194)
      rgb[1].should be_within(deviation).of(0.5000211204153698)
      rgb[2].should be_within(deviation).of(0.25000732006691057)
    end
  end
end