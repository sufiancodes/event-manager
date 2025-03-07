# frozen_string_literal: true

require "time"
require "date"
require "csv"
require "erb"

# opening the CSV file for reading
content = CSV.open(
  "event_attendees.csv",
  headers: true,
  header_converters: :symbol,
)

# method to clean phone numbers
def clean_phone_number(number)
  number = number.to_s.tr("^0-9", "")
  if number.length < 10
    "0000000000"
  elsif number.length == 10
    number
  elsif number.length == 11
    if number.chars[0] == 1
      number.delete_prefix("1")
    else
      "0000000000"
    end
  elsif number.length > 11
    "0000000000"
  end
end

# method to convert date to day
def date_to_day(datetime)
  date_object = DateTime.strptime(datetime, "%m/%d/%Y %k : %M")
  date_object.wday
end

# method to convert date to hour
def date_to_hour(datetime)
  date_object = DateTime.strptime(datetime, "%m/%d/%Y %k : %M")
  date_object.hour
end

# this block find the most important weekdays
popular_week_day = []
puts "Here most important weekdays"
content.each do |row|
  important_day = date_to_day(row[:regdate])
  popular_week_day = popular_week_day.push(important_day)
  weekdays = popular_week_day.each_with_object(Hash.new(0)) do |value, hash|
    hash[value] += 1
  end
  important_days = popular_week_day.max_by { |value| weekdays[value] }
  # days start with Sunday and its index is 0
  puts important_days
end

# this block find the most important hours and put them
popular_time_array = []
puts "Here are most important hour"
content.each do |row|
  hour = date_to_hour(row[:regdate])
  popular_time_array = popular_time_array.push(hour)
  hours = popular_time_array.each_with_object(Hash.new(0)) do |value, hash|
    hash[value] += 1
  end
  peak_hour = popular_time_array.max_by { |value| hours[value] }
  puts peak_hour
end

# this block puts the name and zipcode of people
puts "Here is name and number"
content.each do |row|
  row[0]
  name = row[:first_name] + " " + row[:last_name]
  phone = clean_phone_number(row[:homephone])
  puts "#{name} #{phone}"
end
