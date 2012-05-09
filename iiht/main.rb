require 'rubygems' if RUBY_VERSION < "1.9"

module IIHT

  class Main < Base
    set :root, File.dirname(__FILE__)

    # Routes
    get '/' do
      haml :index
    end
  end

end