require 'rubygems' if RUBY_VERSION < "1.9"
require 'omniauth'

require File.join(File.dirname(__FILE__), 'model.rb')

module IIHT
  class Main < Base
    set :root, File.dirname(__FILE__)

    use Rack::Session::Cookie, :key => 'rack.session',
                               :path => '/',
                               :expire_after => 2592000,
                               :secret => '6539a8628b0e7d39fabacf0479a159ef'

    use OmniAuth::Builder do
      provider :twitter, 'TzadAI8gaQ0jMZVyp9SPg', 'hVVfW0TXBxWLJZrnfMTFCa69IkrvDhEpvEs0QkpekU'
    end

    # Filters
    ["/", "/posts*", "/users*"].each do |path|
      before path do
        if !session[:user_id]
          session[:previous_url] = request.path
          redirect '/login'
        end
      end
    end

    # Routes
    # login to start
    get '/login/?' do
      haml :login
    end

    # twitter oauth login callback
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

      if session[:previous_url]
        redirect_to = session[:previous_url]
        session[:previous_url] = nil
        redirect redirect_to
      else
        # haml :auth_callback
        redirect '/'
      end
    end

    # logout
    get '/logout/?' do
      session.clear
      redirect '/'
    end

    # show user profile
    get '/users/:id' do
      @user = User.get(params[:id])
      haml :user
    end

    # update attrs of logged in user
    patch '/users/:id' do
      if params[:id].to_i != session[:user_id].to_i
        error 401
      end

      user = User.get(params[:id])
      email = params[:email]
      current_password = params[:current_password]
      new_password = params[:new_password]

      # check current password
      if user.password and !user.password.empty? and !password_check(current_password, user.password)
        error 403
      end

      data = {}
      if new_password and !new_password.empty?
        data[:password] = password_encode(new_password)
      end
      if email and !email.empty?
        data[:email] = email
      end
      if data.empty?
        error 400, 'Nothing changed.'
      end

      if !user.update(data)
        error_msgs = Array.new
        user.errors.each {|e| error_msgs << e[0]}
        error 400, error_msgs.join(';')
      end
    end

    # show all posts
    get '/', '/posts/?' do
      @posts = Post.all(:order => [ :created_at.desc ])
      haml :list
    end

    # show a post detail
    get '/posts/:id' do
      @post = Post.get(params[:id])
      haml :post
    end

    # add new post
    post '/posts/?' do
      post = Post.new(
        :title      => params[:title],
        :body       => params[:body],
        :created_at => Time.now
      )
      post.user_id = session[:user_id]

      if !post.save
        error_msgs = Array.new
        post.errors.each {|e| error_msgs << e[0]}
        error 400, error_msgs.join(';')
      end

      redirect '/'
    end

    # edit a post
    patch '/posts/:id' do
      post = Post.get(params[:id])
      if post.user_id != session[:user_id].to_i
        error 401
      end

      if !post.update(:title => params[:title], :body => params[:body], :edited_at => Time.now)
        error_msgs = Array.new
        post.errors.each {|e| error_msgs << e[0]}
        error 400, error_msgs.join(';')
      end

      haml :_post, :locals => {:post => post}, :layout => false
    end

    # add a comment to a post and return successfully added comment for ajax updating
    post '/posts/:id/comments' do
      post = Post.get(params[:id])

      comment = Comment.new(
        :body       => params[:comment],
        :user_id    => session[:user_id],
        :created_at => Time.now
      )
      post.comments << comment

      if !post.save
        error_msgs = Array.new
        post.errors.each {|e| error_msgs << e[0]}
        error 400, error_msgs.join(';')
      end

      haml :_comment, :locals => {:index => post.comments.count-1, :comment => comment}, :layout => false
    end
  end
end
