require 'machinist/active_record'

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end

User.blueprint do |user|
  username { "user#{sn}" }
  password  { "password#{sn}" }
  email  { "user#{sn}@example.com" }
  confirmed_at { Time.now }
end
