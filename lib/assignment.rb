require 'csv'
require 'erb'

content = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

def get_phone_number(number)
  number = number.to_s
  if number.length < 10
    number = 0000000000
  end
end
content.each do |row|
  puts row[:homephone]
end
