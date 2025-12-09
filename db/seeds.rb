# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

require_relative "../bulkUpload.rb"

puts "Running bulk upload seed..."
BulkUpload.run! if Pattern.count.zero? # or adjust as needed

puts "Formatting tags..."
Pattern.find_each do |p|
  p.update(tags: p.tags.split(/[, ]+/).map(&:strip).reject(&:empty?).join(", "))
end # to normalize tags

