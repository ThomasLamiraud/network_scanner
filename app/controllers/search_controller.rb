class SearchController < ApplicationController
  respond_to :json

  def index
    if params[:ip_address]
      re = "^(192\.168\.([0,1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.([0,1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5]))$"

      if params[:ip_address].match re
        puts "Correct IP"
        adress = IPAddr.new params[:ip_address]

        if ping(adress.to_s)
          puts "Scanning ..."
          result = `nc -z #{adress} 1-1023`

          puts "Result : #{result}"

          ports = result.split(/\n/)

          json_port = ports.map do |p|

            { :port => p.scan(/\w{4} \d{2,}/), :service => p.scan(/\/[a-z]+/).first.tr('/', ''), :status => "Open"}
          end

        else
          json_port = { :status => "Host unreachable" }
        end
      else
        json_port = { :status => "IP Incorrecte" }
      end

      respond_with json_port.to_json

    else
      []
    end
  end

  def ping(host)
    begin
      Timeout.timeout(5) do
        s = TCPSocket.new(host, 'echo')
        s.close
        return true
      end
    rescue Errno::ECONNREFUSED
      return true
    rescue Timeout::Error, Errno::ENETUNREACH, Errno::EHOSTUNREACH
      return false
    end
  end
end
