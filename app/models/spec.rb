require 'date'
class Spec < ActiveRecord::Base

	belongs_to :user
	
	ALL_FIELDS=%w(first_name last_name birthdate city gender)
	STRING_FIELDS=%w(first_name last_name city)
	VALID_GENDERS=["男","女"]
	START_YEAR =1900
	VALID_DATES= DateTime.new(START_YEAR)..DateTime.now
	
	validates_length_of STRING_FIELDS,
										 :maximum=>DB_STRING_MAX_LENGTH
	validates_inclusion_of :gender,
												:in=>VALID_GENDERS,
												:allow_nil=>true,
												:message=>"性别必须是男或者女"
	validate_inclusion_of :birthdate,
												:in=>VALID_DATES,
												:allow_nil=>true,
												:message=>"生日日期错误"
												
end
