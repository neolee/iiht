require 'rubygems' if RUBY_VERSION < "1.9"
require 'sinatra/url_for'
require 'omniauth'

require File.join(File.dirname(__FILE__), 'model.rb')

module IIHT
  class Main < Base

    set :root, File.dirname(__FILE__)

    helpers Sinatra::UrlForHelper

    use Rack::Session::Cookie
    use OmniAuth::Builder do
      provider :twitter, 'TzadAI8gaQ0jMZVyp9SPg', 'hVVfW0TXBxWLJZrnfMTFCa69IkrvDhEpvEs0QkpekU'
    end

    # Filters
    before '/' do
      redirect url_for('/login') unless session[:user_id]
    end

    # Routes
    get '/' do
      @posts = Post.all(:order => [ :created_at.desc ])
      haml :index
    end

    get '/post/new/?' do
      haml :new_post
    end

    post '/post/?' do
      post = Post.new(
        :title      => params[:title],
        :body       => params[:body],
        :created_at => Time.now
      )
      post.user = User.first(:id => session[:user_id])
      post.save

      redirect '/'
    end

    get "/login/?" do
      haml :login
    end

    get "/auth/:provider/callback" do
      @auth = request.env['omniauth.auth']
      twitter = @auth['info']['nickname']
      @user = User.first_or_create({:twitter => twitter}, {
        :username   => twitter,
        :twitter    => twitter,
        :avatar     => @auth['info']['image'],
        :created_at => Time.now
      })
      session[:user_id] = @user.id
      session[:username] = @user.username

      haml :auth_callback
    end

  end
end