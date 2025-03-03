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

puts "Here is name and number"
content.each do |row|
  id = row[0]
  name = row[:first_name] + " " + row[:last_name]
  phone = clean_phone_number(row[:homephone])
  puts "#{name} #{phone}"
end

