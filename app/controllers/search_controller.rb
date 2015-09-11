class SearchController < ApplicationController
  respond_to :json

  # Most famous ports
  H_ports = [{"port" => "21", "service" => "FTP"},
                  {"port" => "22", "service" => "SSH"},
                  {"port" => "23", "service" => "Telnet"},
                  {"port" => "80", "service" => "HTTP"},
                  {"port" => "88", "service" => "kerberos"},
                  {"port" => "139", "service" =>	"NETBIOS Session Service"},
                  {"port" => "443", "service" => "HTTPS"},
                  {"port" => "445", "service" => "Smb"},
                  {"port" => "1194", "service" => "OpenVPN"},
                  {"port" => "1243", "service" => "serialgateway"},
                  {"port" => "3306",	"service" => "Mysql Server"},
                  {"port" => "5002", "service" => "radio free ethernet"},
                  {"port" => "5432", "service" => "PostgreSQL"},
                  {"port" => "5433", "service" => "pyrrho"},
                  {"port" => "5900", "service" => "VNC Server"},
                  {"port" => "9091", "service" => "Transmission"}]

  def index
    if params[:ip_address]
      re = "^(192\.168\.([0,1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.([0,1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5]))$"

      if params[:ip_address].match re
        tab_port = []
        puts "Correct IP"

        # OLD CODE
          # adress = IPAddr.new params[:ip_address]
          adress = params[:ip_address]
        if ping(adress)
          puts "Scanning ..."
          # result = `nc -z #{adress} 1-1023`

          # puts "Result : #{result}"

          for i in (1..1023) do
            open_port(adress, i, tab_port)
          end

          # OLD CODE
            # ports = result.split(/\n/)
          puts tab_port
          json_port = tab_port.map do |p|

            { :port => p.first["port"], :service => p.first["service"], :status => "Open"}

            # OLD CODE
              # { :port => p.scan(/\w{4} \d{2,}/), :service => p.scan(/\/[a-z]+/).first.tr('/', ''), :status => "Open"}
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

  # Use to ping IP to see if its available on the network
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

  # Method to find open port on a specific IP
  def open_port(host, port, tab_port)
    sock = Socket.new(:INET, :STREAM)
    raw = Socket.sockaddr_in(port, host)
    # puts "#{port} open." if sock.connect(raw)
    if sock.connect(raw)
      # Check if port is known in the hash
      if H_ports.any? {|h| h["port"] == port.to_s}
        tab_port.push(H_ports.select{|port_number, service| port_number["port"] == port.to_s })
      else
        tab_port.push([{"port" => port.to_s, "service" => "random service"}])
      end
    end

  rescue (Errno::ECONNREFUSED)
    rescue(Errno::ETIMEDOUT)
  end

end
