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
