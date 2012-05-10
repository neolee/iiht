require 'bundler/setup'
Bundler.require(:default)

require File.join(File.dirname(__FILE__), 'base.rb')
require File.join(File.dirname(__FILE__), 'main.rb')

map "/" do
  run IIHT::Main
end
