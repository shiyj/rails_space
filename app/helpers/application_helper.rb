module ApplicationHelper
  #导航栏简化写法
  def nav_link(text,controller,action="index")
    link_to_unless_current text,:controller=>controller,:action=>action
  end
  #登录认证
  def logged_in?
    session[:user_id]
  end
end
