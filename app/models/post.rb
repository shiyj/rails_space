class Post < ActiveRecord::Base
  belongs_to :blog
  validates_presence_of :title, :body, :blog
  validates_length_of :title, :maximum=>255
  validates_length_of :body,:maximum=>40000
end
