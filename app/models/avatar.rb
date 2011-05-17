class Avatar
	include ActiveModel::Validations
	#文件系统的测试和数据库不同.
	#数据库会生成一个新的test数据库,文件位置则已固定.
	if ENV["RAILS_ENV"]=="test"
		URL_STUB=DIRECTORY="tmp"
	else
		URL_STUB="/images/avatars"
		DIRECTORY=File.join("public","images","avatars")
	end
	def initialize (user,image=nil)
		@user=user
		@image=image
		Dir.mkdir(DIRECTORY) unless File.directory?(DIRECTORY)
	end
	def exists?
		File.exists?(File.join(DIRECTORY,filename))
	end
  alias exist? exists?
	def url
		"#{URL_STUB}/#{filename}"
	end 
	
	def thumbnail_url
		"#{URL_STUB}/#{thumbnail_name}"
	end
	
	def save
		valid_file? and successfull_conversion?
	end
	def delete
		[filename,thumbnail_name].each do |name|
			image="#{DIRECTORY}/#{name}"
			File.delete(image) if File.exists?(image)
		end
	end
	private
	def filename
		"#{@user.screen_name}.png"
	end
	def thumbnail_name
		"#{@user.screen_name}_thumbnail.png"
	end
	def successfull_conversion?
		source=File.join("tmp","#{@user.screen_name}_full_size")
		full_size=File.join(DIRECTORY,filename)
		thumbnail=File.join(DIRECTORY,thumbnail_name)
		File.open(source,"wb"){|f| f.write(@image.read) }
		img=system("convert #{source} -resize 240x330 #{full_size}")
		thumb=system("convert #{source} -resize 50x64 #{thumbnail}")
		File.delete(source) if File.exists?(source)
		unless img and thumb
			#errors 的add和add_to_base是不同的.
			#errors.add_to_base("上传失败!请重新选择头像文件.")
			#在新的rails中改为add(:base,message)
			#为了区分,仍以老的为例.add是对某个对象而言,比如add(:name,'not nil'),结果会出现name not nil.
			#而如果是add_to_base则只出现message中的信息,不加前缀name.
			errors.add(:base,"上传失败!请重新选择头像文件.")
			return false
		end
		return true
	end
	def valid_file?
		if @image.size.zero?
			errors.add(:base,"请选择一个图像文件")
			return false
		end
		unless @image.content_type=~/^image/
			puts "无法识别,请确定输入的文件类型为图像文件."
			errors.add(:base,"无法识别,请确定输入的文件类型为图像文件.")
			return false
		end
		if @image.size>1.megabyte
			puts "图像文件不能大于1M"
			errors.add(:image,"图像文件不能大于1M")
			return false
		end
		return true
	end
	
end
