module NodeData
  class NodeIp

    require 'socket'
    require 'ipaddr'

    ## get host IP by subnet - chef ipaddress doesn't always have the IP I want
    def self.subnet_ipv4(opts)
      subnet_ips = []
      begin
        opts[:network] = IPAddr.new(opts[:network]) if !opts[:network].nil?

        Socket.ip_address_list.each do |e|
          next unless !opts[:network].nil? || opts[:network].include?(e.ip_address)
          next unless !opts[:private] || e.ipv4_private?

          subnet_ips << e.ip_address
        end
      rescue => e
        Chef::Log.error("Failed to parse node IP: #{e}")
      end
      return subnet_ips
    end
  end
end
