require 'sinatra/base'

module PXHelpers
  module DateTime
    def dt_fmt(dt)
      (dt ? dt.strftime("%m/%d/%Y %H:%M") : "")
    end
  end
end