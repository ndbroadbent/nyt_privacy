# From: http://stackoverflow.com/a/7749613/304706
module Enumerable
  def sum
    reduce(:+)
  end

  def mean
    sum / length.to_f
  end

  def sample_variance
    m = mean
    sum = reduce(0) {|sum, i| sum + (i - m) ** 2 }
    sum / (length - 1).to_f
  end

  def standard_deviation
    return Math.sqrt(sample_variance)
  end
end

require 'httparty'
require 'yaml'

headers = YAML.load_file('./headers.yml')

feeds = [
  'http://www.nytimes.com/services/xml/rss/nyt/World.xml',
  'http://www.nytimes.com/services/xml/rss/nyt/US.xml',
  'http://feeds.nytimes.com/nyt/rss/Business',
  'http://feeds.nytimes.com/nyt/rss/Technology',
  'http://www.nytimes.com/services/xml/rss/nyt/Arts.xml',
  'http://www.nytimes.com/services/xml/rss/nyt/Travel.xml'
]

lengths = []

feeds.each do |feed|
  response = HTTParty.get(feed)
  data = response.parsed_response

  puts "Fetching #{feed}..."
  puts "-----------------------------------"

  data['rss']['channel']['item'].each do |item|
    link = [item["link"]].flatten[0]
    next unless link.start_with?("http")

    puts link

    begin
      response = HTTParty.get(link, headers: headers)
      puts " => #{response.length} bytes"
      lengths << response.length
    rescue HTTParty::Error => ex
      puts ex.message
    end
  end
end

mean = lengths.mean.round(2)
std_dev = lengths.standard_deviation.round(2)

puts "Fetched #{lengths.count} articles.\n\n"
puts "Mean length: #{mean}"
puts "Standard deviation: #{std_dev}\n\n"

