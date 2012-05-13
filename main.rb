require 'rubygems' if RUBY_VERSION < "1.9"
require 'sinatra/url_for'
require 'omniauth'

require File.join(File.dirname(__FILE__), 'model.rb')
$: << File.join(File.dirname(__FILE__), '/lib')

module IIHT
  class Main < Base

    set :root, File.dirname(__FILE__)

    helpers Sinatra::UrlForHelper

    use Rack::Session::Cookie
    use OmniAuth::Builder do
      provider :twitter, 'TzadAI8gaQ0jMZVyp9SPg', 'hVVfW0TXBxWLJZrnfMTFCa69IkrvDhEpvEs0QkpekU'
    end

    # Filters
    ["/", "/posts/*"].each do |path|
      before path do
        if !session[:user_id] then
          session[:previous_url] = request.path
          redirect '/login'
        end
      end
    end

    # Routes
    get '/login/?' do
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

      if session[:previous_url] then
        redirect_to = session[:previous_url]
        session[:previous_url] = nil
        redirect redirect_to
      else
        haml :auth_callback
      end
    end

    ["/", "/posts/?"].each do |path|
      get path do
        @posts = Post.all(:order => [ :created_at.desc ])
        haml :list
      end
    end

    get '/posts/new/?' do
      haml :new
    end

    post '/posts/?' do
      post = Post.new(
        :title      => params[:title],
        :body       => params[:body],
        :created_at => Time.now
      )
      post.user = User.first(:id => session[:user_id])
      post.save

      redirect '/posts/'
    end

    get '/users/:id' do
      @user = User.get(params[:id])
      haml :user
    end

    patch '/users/:id' do
      user = User.get(params[:id])
      user.update(:email => params[:email], :password => params[:password])
      redirect "/users/#{params[:id]}"
    end

  end
end