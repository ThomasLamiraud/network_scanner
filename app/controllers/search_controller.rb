class SearchController < ApplicationController
  def index
    if params[:ip_address]
      re = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"

      if adress.match re
        puts "Correct IP"
        puts "Scanning ..."
        adress = IPAddr.new adress

        @result = `nc -z #{adress} 1-1023`

        puts "Result : "
        puts result
      else
        puts "IP Incorrect"
      end

    else
      []
    end
  end
end
