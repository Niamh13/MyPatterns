require 'csv'

module BulkUpload
  def self.run!
    csv = CSV.open('patterns.csv', headers: true)
    [:convert, :header_convert].each { |c| csv.send(c) { |f| f.strip } }

    csv.each do |row|
      # Create Pattern record directly in DB
      Pattern.create!(
        title: row['title'],
        source: row['source'],
        rating: row['rating'],
        difficulty: row['difficulty'],
        made: row['made'],
        tags: row['tags'],
        yarn_weight: row['yarn_weight'],
        stitch_type: row['stitch_type'],
        size: row['size'],
        notes: row['notes'],
        link: row['link'],
        user_id: row['user_id']
      )
    end
  end
end
