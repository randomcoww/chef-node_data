module NodeData
  class NodeIp

    require 'socket'
    require 'ipaddr'

    ## get host IP by subnet - chef ipaddress doesn't always have the IP I want
    def self.subnet_ipv4(network)
      subnet_ips = []
      begin
        n = IPAddr.new(network)

        Socket.ip_address_list.each do |e|
          if e.ipv4_private? && n.include?(e.ip_address)
            subnet_ips << e.ip_address
          end
        end
      rescue => e
        Chef::Log.error("Failed to parse node IP: #{e}")
      end
      return subnet_ips
    end
  end
end
