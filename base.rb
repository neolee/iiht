require 'rubygems' if RUBY_VERSION < "1.9"
require 'sinatra/url_for'

$: << File.join(File.dirname(__FILE__), '/helpers')
require 'dt.rb'
require 'html.rb'
require 'http.rb'
require 'password.rb'
require 'string.rb'

class Base < Sinatra::Base
  register Sinatra::MultiRoute

  register PXHelpers::DateTime
  register PXHelpers::HTML
  register PXHelpers::HTTP
  register PXHelpers::Password
  register PXHelpers::String

  configure :development do
    enable  :sessions, :clean_trace, :inline_templates, :logging
    disable :dump_errors
    set :static, true
    set :public_folder, File.dirname(__FILE__) + '/public'
    set :session_secret, 'shotgun sucks on sessions'
  end

  configure do
    enable :static, :sessions
    set :haml, { :format => :html5 }
  end

  helpers Sinatra::UrlForHelper

  helpers PXHelpers::DateTime
  helpers PXHelpers::HTML
  helpers PXHelpers::HTTP
  helpers PXHelpers::Password
  helpers PXHelpers::String
end
