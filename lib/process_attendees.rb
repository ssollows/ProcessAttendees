require 'active_model'
require 'email_validator'
require 'action_view'
include ActionView::Helpers::NumberHelper
require 'csv'
require 'phone'

def init
    valid_attendees = Array.new
    invalid_attendees = Array.new
    attendees = Array.new
    keys = ['firstname', 'lastname', 'email', 'phone']
    
    attendees = CSV.read('attendee_data/raw_attendees.csv').map {|a| Hash[ keys.zip(a) ]}
    attendees.each do |element|
        normalize_phone_number(element['phone'])
        if EmailValidator.valid?(element['email'])
            puts 'phone is good and true'
            valid_attendees.push(element)
            else
            puts 'phone is bad and false'
            invalid_attendees.push(element)
        end
    end
end

def normalize_phone_number(num)
end

init()