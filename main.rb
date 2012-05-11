require 'rubygems' if RUBY_VERSION < "1.9"
require 'sinatra/url_for'

require File.join(File.dirname(__FILE__), 'model.rb')

module IIHT

  class Main < Base
    set :root, File.dirname(__FILE__)

    helpers Sinatra::UrlForHelper

    # Routes
    get '/' do
      @posts = Post.all(:order => [ :created_at.desc ])
      haml :index
    end

    get '/post/new' do
      haml :new_post
    end

    post '/post/' do
      post = Post.new(
        :title      => params[:title],
        :body       => params[:body],
        :created_at => Time.now
      )
      post.user = User.first(:id => 1)
      post.save

      redirect '/'
    end
  end

end