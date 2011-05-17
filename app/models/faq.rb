class Faq < ActiveRecord::Base
	belongs_to :user
	QUESTIONS=%w(bio schools music movies books)
	FAVORITES= QUESTIONS-%w(bio)
	TEXT_ROWS=10
	TEXT_CLOS=40
	validates_length_of QUESTIONS, :maximum=>40000
	
	def initialize
		super
		QUESTIONS.each do |question|
			self[question]=""
		end
	end
	
end
