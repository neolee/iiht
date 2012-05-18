require 'rubygems' if RUBY_VERSION < "1.9"
require 'data_mapper'

# DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'mysql://iiht:nirvana@localhost/iiht')

# Entities
class User
  include DataMapper::Resource
  property :id, Serial
  property :username, String
  property :twitter, String, :length => 120
  property :email, String, :length => 120, :format => :email_address
  property :password, String, :length => 200
  property :avatar, String, :length => 255
  property :enabled, Boolean, :default  => true
  property :created_at, DateTime
end

class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String, :length => 140, :required => true 
  property :body, Text
  property :created_at, DateTime
  property :edited_at, DateTime
end

class Vote
  include DataMapper::Resource
  property :id, Serial
  property :love, Boolean, :default  => true
  property :created_at, DateTime
end

class Comment
  include DataMapper::Resource
  property :id, Serial
  property :body, Text
  property :hidden, Boolean, :default  => false
  property :created_at, DateTime
end

# Relationships
class User
  has n, :posts
  has n, :votes
  has n, :comments
end

class Post
  belongs_to :user

  has n, :votes
  has n, :comments
end

class Vote
  belongs_to :user
  belongs_to :post
end

class Comment
  belongs_to :user
  belongs_to :post
end

DataMapper.finalize

User.auto_upgrade!
Post.auto_upgrade!
Vote.auto_upgrade!
Comment.auto_upgrade!
