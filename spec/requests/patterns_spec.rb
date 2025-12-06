require "rails_helper"

RSpec.describe "Patterns API", type: :request do
  let!(:pattern) do
    Pattern.create!(
      title: "Hat",
      source: "Website",
      rating: 4,
      difficulty: 2,
      made: 1,
      tags: "hat, winter",
      yarn_weight: "medium",
      stitch_type: "single crochet",
      size: "small",
      notes: "Warm hat",
      link: "http://example.com",
      user_id: 1
    )
  end

  describe "GET /patterns" do
    it "returns all patterns" do
      get "/patterns"
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(json.first["title"]).to eq("Hat")
    end
  end

  describe "POST /patterns" do
    it "creates a new pattern" do
      expect {
        post "/patterns", params: {
          pattern: {
            title: "Scarf",
            source: "Blog",
            rating: 5,
            difficulty: 3,
            made: 0,
            tags: "scarf",
            yarn_weight: "light",
            stitch_type: "knit",
            size: "medium",
            notes: "abcde",
            link: "http://example.com",
            user_id: 2
          }
        }
      }.to change { Pattern.count }.by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe "PUT /patterns/:id" do
    it "updates a pattern" do
      put "/patterns/#{pattern.id}", params: {
        pattern: { title: "New Title" }
      }

      expect(response).to have_http_status(:ok)
      expect(pattern.reload.title).to eq("New Title")
    end
  end

  describe "DELETE /patterns/:id" do
    it "deletes a pattern" do
      expect {
        delete "/patterns/#{pattern.id}"
      }.to change { Pattern.count }.by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
