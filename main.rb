require 'rubygems' if RUBY_VERSION < "1.9"
require 'omniauth'

require File.join(File.dirname(__FILE__), 'model.rb')

module IIHT
  class Main < Base
    set :root, File.dirname(__FILE__)

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
        # haml :auth_callback
        redirect '/'
      end
    end

    get '/logout/?' do
      session.clear
      redirect '/'
    end

    get '/', '/posts/?' do
      @posts = Post.all(:order => [ :created_at.desc ])
      haml :list
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
      if params[:id].to_i == session[:user_id].to_i then
        user = User.get(params[:id])
        email = params[:email]
        current_password = params[:current_password]
        new_password = params[:new_password]
        
        # check current password
        if !user.password or user.password.empty? or password_check(current_password, user.password) then
          if new_password and !new_password.empty? then
            password_hash = password_encode(new_password)
            user.update(:email => email, :password => password_hash)
          else
            if email and !email.empty? then
              user.update(:email => params[:email])
            end
          end
        else
          # current password error, no change permitted
          error 403
        end
      end
    end

    get '/posts/:id' do
      @post = Post.get(params[:id])
      haml :post
    end

    patch '/posts/:id' do
      post = Post.get(params[:id])
      if post.user_id == session[:user_id].to_i then
        post.update(:title => params[:title], :body => params[:body], :edited_at => Time.now)
      end
    end

  end
end