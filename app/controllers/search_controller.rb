class SearchController < ApplicationController
  respond_to :json
  def index
    if params[:ip_address]
      re = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"

      if params[:ip_address].match re
        puts "Correct IP"
        puts "Scanning ..."
        adress = IPAddr.new params[:ip_address]

        result = `nc -z #{adress} 1-1023`

        puts "Result : "
        respond_with result
      else
        puts "IP Incorrect"
      end

    else
      []
    end
  end
end
