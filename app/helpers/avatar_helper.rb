module AvatarHelper
	def avatar_tag(user)
		image_tag(user.avatar.url,:border=>1)
	end
	def thumbnail_tag(user)
		image_tag(user.avatar.thumbnail_url,:border=>1)
	end
end
