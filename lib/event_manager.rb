# frozen_string_literal: true

require "csv"
require "google/apis/civicinfo_v2"
require "erb"

# cleaning zipcode for use
def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

# sorting zipcode by legislator
def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = "AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw"
  # handling the case where the info is not available
  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: "country",
      roles: ["legislatorUpperBody", "legislatorLowerBody"],
    ).officials
  rescue
    "You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials"
  end
end

# creating and saving a thankyou letter
def save_thank_you_letter(id, form_letter)
  Dir.mkdir("output") unless Dir.exist?("output")

  filename = "output/thanks_#{id}.html"

  File.open(filename, "w") do |file|
    file.puts form_letter
  end
end

puts "EventManager initialized."
# opening the CSV file
contents = CSV.open(
  "event_attendees.csv",
  headers: true,
  header_converters: :symbol,
)

# generating templates
template_letter = File.read("form_letter.erb")
erb_template = ERB.new(template_letter)

# this block generate name and zipcode and save them in output folder
contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id, form_letter)
end
