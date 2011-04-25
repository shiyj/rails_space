ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def assert_form_tag(action)
  	assert_tag "form",:attributes=>{:action=>action,:method=>"post"}
  end
  
  def assert_submit_button(button_label=nil)
  	if button_label
  		assert_tag "input",:attributes=>{:type=>"submit",:value=>button_label}
  	else
  		assert_tag "input",:attributes=>{:type=>"submit"}
  	end
  end
  
  def assert_input_field(name,value,field_type,size,maxlength,options={})
  	attributes={:name=>name,
  							:type=>field_type,
  							:size=>size,
  							:maxlength=>maxlength}
  	attributes[:value]=value unless value.nil?
  	tag={:tag=>"input",:attributes=>attributes}
  	tag.merge!(options)
  	assert_tag tag
  end
  
end
