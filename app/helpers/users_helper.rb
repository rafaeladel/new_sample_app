module UsersHelper
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email)
    gravatar_link = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag gravatar_link, alt: user.name, class: 'gravatar'
  end
end
