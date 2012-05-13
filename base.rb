require 'rubygems' if RUBY_VERSION < "1.9"

class Base < Sinatra::Base

  configure :development do
    enable  :sessions, :clean_trace, :inline_templates, :logging
    disable :dump_errors
    set :static, true
    set :public_folder, File.dirname(__FILE__) + '/public'
    set :session_secret, 'shotgun sucks on sessions'
  end

  enable :static, :sessions
  set :haml, { :format => :html5 }

end
