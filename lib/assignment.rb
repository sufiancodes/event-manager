require 'time'
require 'date'
require 'csv'
require 'erb'

content = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

def clean_phone_number(number)
  number = number.to_s.tr('^0-9', '')
  if number.length < 10
    number = "0000000000"
  elsif number.length == 10
    number
  elsif number.length == 11
    if number.chars[0] == 1
      number.delete_prefix('1')
    else
      number = "0000000000"
    end
  elsif number.length > 11
    number = "0000000000"
  end
end



def date_to_hour(datetime)
  date_object = DateTime.strptime(datetime, '%m/%d/%Y %k : %M')
  hour = date_object.hour
end


popular_time_array = []
puts "Here are most important hour"
content.each do |row|
  hour = date_to_hour(row[:regdate])
  popular_time_array = popular_time_array.push(hour)
  hours = popular_time_array.inject(Hash.new(0)) {|hash, value| hash[value] += 1 ; hash}
  peak_hour = popular_time_array.max_by {|value| hours[value]}
  puts peak_hour
end

puts "Here is name and number"
content.each do |row|
  id = row[0]
  name = row[:first_name] + " " + row[:last_name]
  phone = clean_phone_number(row[:homephone])
  puts "#{name} #{phone}"
end



