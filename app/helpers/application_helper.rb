module ApplicationHelper
	require 'string'
  #导航栏简化写法
  def nav_link(text,controller,action="index")
    link_to_unless_current text,:controller=>controller,:action=>action
  end
  #登录认证
  def logged_in?
    session[:user_id]
  end
  #conten_tag的原型:ontent_tag(name, content_or_options_with_block = nil, options = nil, escape = true, &block)
  #其中 第1个参数是html的标签名称,下边的"label"被解释为<label></label>
  #第2个参数为第一个标签所包围的html元素.
  #label的for标签表示于一个相同的id表单绑定.
  def text_field_for(form,field,size=HTML_TEXT_FIELD_SIZE,
  											 maxlength=DB_STRING_MAX_LENGTH)
  	labels=content_tag(:label,"#{field.humanize}:",:for=>field)
  	form_fields=form.text_field field ,:size=>size,:maxlength=>maxlength
  	#两个之间使用+号来结合.
  	content_tag(:div,labels+form_fields,:class=>"form_row")
  end
end
