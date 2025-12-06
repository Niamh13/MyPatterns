require "rails_helper"
require "yarn_calculator"

RSpec.describe YarnCalculator do
  it "calculates correct yarn estimate" do
    result = YarnCalculator.estimate("medium", "single crochet", "medium")
    expect(result).to be > 0
  end

  it "changes output based on stitch type" do
    a = YarnCalculator.estimate("medium", "single crochet", "small")
    b = YarnCalculator.estimate("medium", "double crochet", "small")
    expect(b).to be > a
  end
end
