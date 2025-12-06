require "rails_helper"

RSpec.describe Pattern, type: :model do
  let(:valid_attributes) do
    {
      title: "Scarf",
      source: "Ravelry",
      rating: 4,
      difficulty: 3,
      made: 1,
      tags: "scarf, cozy",
      yarn_weight: "medium",
      stitch_type: "single crochet",
      size: "medium",
      notes: "Lovely scarf",
      link: "http://example.com",
      user_id: 1
    }
  end

  it "is valid with valid attributes" do
    pattern = Pattern.new(valid_attributes)
    expect(pattern).to be_valid
  end

  it "requires a title" do
    pattern = Pattern.new(valid_attributes.merge(title: nil))
    expect(pattern).not_to be_valid
  end

  it "normalizes tags into comma-separated format" do
    pattern = Pattern.create(valid_attributes.merge(tags: "scarf   cozy winter"))
    expect(pattern.tags).to eq("scarf, cozy, winter")
  end

  it "calculates yarn_estimate before save" do
    pattern = Pattern.create(valid_attributes)
    expect(pattern.yarn_estimate).to be_present
    expect(pattern.yarn_estimate).to be > 0
  end

  it "rejects invalid yarn_weight options" do
    pattern = Pattern.new(valid_attributes.merge(yarn_weight: "invalid"))
    expect(pattern).not_to be_valid
  end
end
