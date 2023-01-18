require "open-uri"
require "json"

puts "========================================"
puts "    Will you need an umbrella today?    "
puts "========================================"
puts ""
puts "Where are you?"

user_location = gets.chomp

puts "Checking the weather at " + user_location + "...."

gmaps_api_endpoint = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + ENV.fetch("GMAPS_KEY")
gmaps_parsed_data = JSON.parse(URI.open(gmaps_api_endpoint).read)
gmaps_results_array = gmaps_parsed_data.fetch("results")
loc = gmaps_results_array[0].fetch("geometry").fetch("location")
latitude = loc.fetch("lat")
longitude = loc.fetch("lng")

puts "Your coordinates are " + latitude.to_s + ", " + longitude.to_s + "."

darksky_api_endpoint = "https://api.darksky.net/forecast/" + ENV.fetch("DARK_SKY_KEY") + "/" + latitude.to_s + "," + longitude.to_s
darksky_parsed_data = JSON.parse(URI.open(darksky_api_endpoint).read)
temperature = darksky_parsed_data.fetch("currently").fetch("temperature")
summary = darksky_parsed_data.fetch("minutely").fetch("summary")

puts "It is currently " + temperature.to_s + "°F."
puts "Next hour: " + summary

hourly_array = darksky_parsed_data.fetch("hourly").fetch("data")
umbrella = false

13.times do |hour|
  probability = hourly_array[hour].fetch("precipProbability")
  if probability > 0.1 && hour > 0
    puts "In " + (hour).to_s + " hours, there is a " + (probability * 100).round.to_s + "% chance of precipitation."
    umbrella = true
  end
end

if umbrella
  puts "You might want to take an umbrella!"
else
  puts "You probably won't need an umbrella."
end
