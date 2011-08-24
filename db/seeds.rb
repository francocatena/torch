# Default user
user = User.new(
  :name => 'Administrator',
  :lastname => 'Administrator',
  :email => 'admin@torch.com',
  :password => 'admin123',
  :password_confirmation => 'admin123'
)

puts(user.save ? 'User [OK]' : user.errors.full_messages.join("\n"))