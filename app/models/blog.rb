class Blog < ActiveRecord::Base
  belongs_to :user
  has_many :comments,:order=>"created_at",:dependent=> :destroy
  has_many :posts, :order=> "created_at DESC"
end
