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
    validates :yarn_weight, inclusion: { in: available_weight, message: "%{value} is not a valid yarn weight" }
    validates :stitch_type, inclusion: { in: available_stitch, message: "%{value} is not a valid stitch type" }
    validates :size, inclusion: { in: available_size, message: "%{value} is not a valid stitch type" }
    validates :notes, length: {minimum: 10}
    validates :link, presence:true

    before_validation :calculate_estimate_yarn, if: -> { yarn_weight.present? && stitch_type.present? && size.present? }

    private 

    def calculate_estimate_yarn
        self.estimate_yarn = YarnCalculator.estimate(yarn_weight, stitch_type, size)
    end
    
end
