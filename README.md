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
