require "rails_helper"
require "recommendation_system"

RSpec.describe RecommendationSystem do
  it "returns patterns with matching tags" do
    p1 = Pattern.create!(
      title: "Pattern A", source: "x", link: "x", made: 1,
      tags: "scarf, warm", yarn_weight: "medium",
      stitch_type: "single crochet", size: "medium",
      notes: "abcde", rating: 3, difficulty: 2
    )

    p2 = Pattern.create!(
      title: "Pattern B", source: "x", link: "x", made: 1,
      tags: "scarf, cozy", yarn_weight: "medium",
      stitch_type: "single crochet", size: "medium",
      notes: "abcde", rating: 3, difficulty: 2
    )

    recs = RecommendationSystem.similar_patterns(p1, Pattern.all)
    expect(recs).to include(p2)
  end
end
