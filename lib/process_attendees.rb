require 'active_model'
require 'email_validator'
require 'action_view'
require 'csv'
require 'phone'
require 'yaml'
require 'json'
include ActionView::Helpers::NumberHelper
include Enumerable

def init
    # Set the deafult country code (required by the Phone gem)
    Phoner::Phone.default_country_code = '1'
    valid_attendees = Array.new
    invalid_attendees = Array.new
    attendees = Array.new
    
    # Get the attendees from the CSV into an array
    keys = ['firstname', 'lastname', 'email', 'phone']
    attendees = CSV.read('attendee_data/raw_attendees.csv').map {|a| Hash[ keys.zip(a) ]}
    
    # Sort through each attendee and check for a valid email and duplicates
    attendees.each do |element|
        duplicate = valid_attendees.any? {|h| h['email'] == element['email']}
        if EmailValidator.valid?(element['email']) && !duplicate
            #Normalize the phone number if the email is valid
            element['phone'] = normalize_phone_number(element['phone']).to_s
            valid_attendees.push(element)
        else
            invalid_attendees.push(element)
        end
    end
    
    # Generate the files for Invalid and Valid Attendees
    generate_valid_attendees(valid_attendees)
    generate_invalid_attendees(invalid_attendees)
end

# Using Phone to normalize the phone number
def normalize_phone_number(num)
    number = Phoner::Phone.parse(num)
    # Formats as (area code) XXX XXXX
    number = number.format('(%a) %f %l')
end

# Generates the JSON for Valid Attendees
def generate_valid_attendees(attendees)
    File.open("valid_attendees.json","w") do |f|
        f.write(attendees.map { |o| Hash[o.each_pair.to_a] }.to_json)
   end
end

# Generates the txt for Invalid Attendees
def generate_invalid_attendees(attendees)
    File.open("invalid_attendees.txt","w") do |f|
        attendees.each { |element| f.puts(element['lastname']+' - '+element['firstname']+' - '+element['email']+' - '+element['phone']) }
    end
end

init()