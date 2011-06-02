# encoding: utf-8
require 'date'
class Spec < ActiveRecord::Base

	belongs_to :user
	
	ALL_FIELDS=%w(first_name last_name birthdate city gender)
	STRING_FIELDS=%w(first_name last_name city)
	VALID_GENDERS=["男","女"]
	START_YEAR =1900
	VALID_DATES= DateTime.new(START_YEAR)..DateTime.now
	
	validates_length_of STRING_FIELDS,
										 :maximum=>255
	validates_inclusion_of :gender,
												:in=>VALID_GENDERS,
												:allow_nil=>true,
												:message=>"性别必须是男或者女"
	validates_inclusion_of :birthdate,
												:in=>VALID_DATES,
												:allow_nil=>true,
												:message=>"生日日期错误"
	def full_name
		[first_name,last_name].join(" ")
	end
	
	def age
		return if birthdate.nil?
		today=Date.today
		if today.month > birthdate.month and today.day>=birthdate.day
			today.year - birthdate.year
		else
			today.year - birthdate.year - 1
		end
	end								
end
