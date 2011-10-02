class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  validates_presence_of :body, :post, :user
  validates_length_of :body, :maximum => 40000
  #防止出现重复评论
  validates_uniqueness_of :body, :scope => [:post_id, :user_id]
  #判断是否是重复评论
  def duplicate?
    c = Comment.find_by_post_id_and_user_id_and_body(post, user, body)
    # Give self the id for REST routing purposes.
    self.id = c.id unless c.nil?
    not c.nil?
  end
  
  #验证，用于删除时。
  def authorized?(user)
    post.blog.user == user
  end
end
