module RecommendationSystem
  def self.similar_patterns(pattern, all_patterns)
    # Exclude the current pattern
    all_patterns = all_patterns.reject { |p| p.id == pattern.id }

    all_patterns.map do |other|
      # Split tags and clean up whitespace
      pattern_tags = pattern.tags.to_s.split(",").map(&:strip)
      other_tags = other.tags.to_s.split(",").map(&:strip)

      # Handle empty tags safely
      next if pattern_tags.empty? || other_tags.empty?

      # Calculate tag overlap (Jaccard similarity)
      tag_overlap = (pattern_tags & other_tags).size.to_f / (pattern_tags | other_tags).size

      # Compare difficulty (normalized)
      diff_score = 1.0 - ((pattern.difficulty - other.difficulty).abs / 5.0)

      # Weighted similarity
      similarity = (0.7 * tag_overlap) + (0.3 * diff_score)
      [other, similarity]
    end.compact.sort_by { |_, score| -score }.map(&:first).take(5)
  end
end
