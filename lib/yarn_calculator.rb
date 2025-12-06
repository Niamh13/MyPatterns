module YarnCalculator
    YARN_FACTORS = {
        "lace" => 0.8,
        "light" => 1.0,
        "medium" => 1.2,
        "bulky" => 1.4,
        "super bulky" => 1.6
    }

    STITCH_FACTORS = {
        "single crochet" => 1.0,
        "half double crochet" => 1.1,
        "double crochet" => 1.3,
        "knit" => 1.1,
        "purl" => 1.0
    }

    SIZE_FACTORS = {
        "small" => 1.0,
        "medium" => 1.5,
        "large" => 2.0
    }

    # meters baseline
    BASE_LENGTH = 100
    
    def self.estimate(yarn_weight, stitch_type, size)
        yarn_factor = YARN_FACTORS[yarn_weight.downcase]
        stitch_factor = STITCH_FACTORS[stitch_type.downcase]
        size_factor = SIZE_FACTORS[size.downcase]

        return nil if [yarn_factor, stitch_factor, size_factor].any?(&:nil?)

        (BASE_LENGTH * yarn_factor * stitch_factor * size_factor).round(1)
    end
end

