require 'net/http'
require 'json'
require 'csv'    

csv = CSV.open('patterns.csv', :headers => true)
[:convert, :header_convert].each { |c| csv.send(c) { |f| f.strip } }

def send_data(payload)
  uri = URI('http://127.0.0.1:3000/patterns')
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.path,
                              'Content-Type' => 'application/json',
                              'Accept' => 'application/json')
    req.body = payload.to_json
    res = http.request(req)
    puts "response #{res.body}"
rescue => e
    puts "failed #{e}"
end

# Send data from the CSV to the backend
csv.each do |row|
  send_data(row.to_hash)
end
