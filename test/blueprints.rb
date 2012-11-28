require 'machinist/active_record'

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end

Organization.blueprint do
  title { "Some Organization #{sn}" }
  slug  { "so_#{sn}" }
  description  { "We do stuff.  It's grand." }
end

User.blueprint do |user|
  username { "user#{sn}" }
  password  { "password#{sn}" }
  email  { "user#{sn}@example.com" }
  confirmed_at { Time.now }
end
