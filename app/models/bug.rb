class Bug < ApplicationRecord
    before_create :add_number

    has_one :state
    accepts_nested_attributes_for :state , :allow_destroy => true

	
	enum status: [:neww, :in_progress, :closed ]
	enum priority: [:minor, :major, :critical ]

    private

	def add_number
	    self.class.exists?(application_token: application_token) ? self.number = Bug.where(application_token: application_token).pluck("number").sort.last + 1 : self.number = 1	
	end

	# def check_token_app
	# 	unless App.find_by access_token: application_token
	# 		raise ArgumentError.new('This Application is not found') 
	# 	end 
	# end

end