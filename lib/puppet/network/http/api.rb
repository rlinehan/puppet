class Puppet::Network::HTTP::API
  def self.not_found
    Puppet::Network::HTTP::Route.
      path(/.*/).
      any(lambda do |req, res|
        raise Puppet::Network::HTTP::Error::HTTPNotFoundError.new("No route for #{req.method} #{req.path}", Puppet::Network::HTTP::Issues::HANDLER_NOT_FOUND)
      end)
  end

  def self.master_routes
    master_prefix = Regexp.new("^#{Puppet[:master_url_prefix]}")
    Puppet::Network::HTTP::Route.path(master_prefix).
      any.
      chain(Puppet::Network::HTTP::API::V3.master_routes,
            Puppet::Network::HTTP::API::V2.routes,
            Puppet::Network::HTTP::API.not_found)
  end

  def self.ca_routes
    ca_prefix = Regexp.new("^#{Puppet[:ca_url_prefix]}")
    Puppet::Network::HTTP::Route.path(ca_prefix).
      any.
      chain(Puppet::Network::HTTP::API::V3.ca_routes,
            Puppet::Network::HTTP::API.not_found)
  end
end
