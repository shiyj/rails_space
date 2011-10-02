class Post < ActiveRecord::Base
  belongs_to :blog
  has_many :comments, :order=>"created_at",:dependent=> :destroy
  validates_presence_of :title, :body, :blog
  validates_length_of :title, :maximum=>255
  validates_length_of :body,:maximum=>40000
  #如果多次提交相同的内容则忽略提交
  def duplicate?
    post=Post.find_by_blog_id_and_title_and_body(blog_id,title,body)
    self.id=post.id unless post.nil?
    not post.nil?
  end
end
