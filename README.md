# My-Patterns
Cloud Application Development: CAD Project

A crochet and kintting pattern application where users can store and share links to patterns
- The users can add, delete, edit, and view their added records
- Pattern Recommendation Engine: recommends similar patterns based off difficulty rating and tags (personalized descovery)
- Yarn Usage Calculator: Estimates the total yarn length needed based off the yarn weight (light, medium, or bulky), main stitch type (single crochet, double crochet, knit, purl), and size of the project (small, meduim, or large)


# Back-End Setup
_Create App_
rails new patterns --api
cd patterns
rails generate scaffold Pattern title:string source:string rating:float difficulty:float made:integer tags:string yarn_weight:string stitch_type:string size:string yarn_estimate:float notes:string link:string user_id:integer
rails db:migrate
gem install rack-cors

_Validations_
class Pattern < ApplicationRecord
validates :title, presence:true
validates :source, presence:true
validates :rating, comparison: {greater_than_or_equal_to:0, less_than_or_equal_to:5, message: "Rate for 0 to 5"}
validates :difficulty, comparison: {greater_than_or_equal_to:0, less_than_or_equal_to:5, message: "Rate for 0 to 5"}
validates :made, presence:true
validates :notes, length: {minimum: 10}
validates :link, presence:true
end

_Library_
recommendation_system.rb
yarn_calculator.rb

=======
# My-Patterns
Cloud Application Development: CAD Project

A crochet and kintting pattern application where users can store and share links to patterns
- The users can add, delete, edit, and view their added records
- Pattern Recommendation Engine: recommends similar patterns based off difficulty rating and tags (personalized descovery)
- Yarn Usage Calculator: Estimates the total yarn length needed based off the yarn weight (light, medium, or bulky), main stitch type (single crochet, double crochet, knit, purl), and size of the project (small, meduim, or large)


# Back-End Setup
_Create App_
rails new patterns --api
cd patterns
rails generate scaffold Pattern title:string source:string rating:float difficulty:float made:integer tags:string yarn_weight:string stitch_type:string size:string yarn_estimate:float notes:string link:string user_id:integer
rails db:migrate
gem install rack-cors

_Validations_
class Pattern < ApplicationRecord
    # allowes options
    available_weight = ["lace", "light", "medium", "bulky", "super bulky"].freeze
    available_stitch = ["single crochet", "double crochet", "half double crochet", "knit", "purl"].freeze
    available_size = ["small", "medium", "large"].freeze
    validates :title, presence:true
    validates :source, presence:true
    validates :rating, comparison: {greater_than_or_equal_to:0, less_than_or_equal_to:5, message: "Rate for 0 to 5"}, allow_nil: true
    validates :difficulty, comparison: {greater_than_or_equal_to:0, less_than_or_equal_to:5, message: "Rate for 0 to 5"}, allow_nil: true
    validates :made, presence:true
    validates :tags, presence:true
    validates :yarn_weight, inclusion: { in: available_weight}
    validates :stitch_type, inclusion: { in: available_stitch}
    validates :size, inclusion: { in: available_size}
    validates :notes, length: {minimum: 5}
    validates :link, presence:true
    before_validation :calculate_estimated_yarn, if: -> { yarn_weight.present? && stitch_type.present? && size.present? }
    before_save :normalize_tags
    scope :search, -> (term) {
      where("LOWER(title) LIKE :term OR LOWER(tags) LIKE :term", term: "%#{term.downcase}%")
    }
  private
  def calculate_estimated_yarn
    self.yarn_estimate = YarnCalculator.estimate(yarn_weight, stitch_type, size)
  end
  def normalize_tags
    return if !tags.present?
    formatted = tags.split(/[, ]+/).map(&:strip).reject(&:empty?).join(", ")
    self.tags = formatted
  end
end


_Library_
recommendation_system.rb
yarn_calculator.rb
>>>>>>> c950365e0e9762e70a26ee1043e6ba8c27a37df1
