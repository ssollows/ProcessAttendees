require 'active_model'
require 'email_validator'
require 'action_view'
require 'csv'
require 'phone'
require 'yaml'
include ActionView::Helpers::NumberHelper

def init
    Phoner::Phone.default_country_code = '1'
    valid_attendees = Array.new
    invalid_attendees = Array.new
    attendees = Array.new
    keys = ['firstname', 'lastname', 'email', 'phone']
    
    attendees = CSV.read('attendee_data/raw_attendees.csv').map {|a| Hash[ keys.zip(a) ]}

    attendees.each do |element|
        if EmailValidator.valid?(element['email'])
            element['phone'] = normalize_phone_number(element['phone']).to_s
            valid_attendees.push(element)
        else
            invalid_attendees.push(element)
        end
    end
    puts valid_attendees
    puts "==============="
    puts invalid_attendees
end

def normalize_phone_number(num)
    number = Phoner::Phone.parse(num)
    number = number.format('(%a) %f-%l')
end

init()