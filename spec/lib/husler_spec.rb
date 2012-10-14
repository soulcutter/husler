require 'spec_helper'

describe Husler do
  context "#rgb_to_husl" do
    it "matches the expected output from the canonical coffeescript implementation" do
      # jQuery.husl.fromRGB(0.75, 0.5, 0.25);
      Husler.rgb_to_husl(0.75, 0.5, 0.25).should == [41.92580295066964, 78.60025347503503, 58.774191389329374]
    end
  end

  context "#husl_to_rgb" do
    it "matches the expected output from the canonical coffeescript implementation" do
      # jQuery.husl.toRGB(41.92580295066964, 78.60025347503503, 58.774191389329374)
      Husler.husl_to_rgb(41.92580295066964, 78.60025347503503, 58.774191389329374).should ==
          [0.7499979858220194, 0.5000211204153698, 0.25000732006691057]
    end
  end
end