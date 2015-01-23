class Puppet::Network::HTTP::API
  def self.not_found
    Puppet::Network::HTTP::Route.
      path(/.*/).
      any(lambda do |req, res|
        raise Puppet::Network::HTTP::Error::HTTPNotFoundError.new("No route for #{req.method} #{req.path}", Puppet::Network::HTTP::Issues::HANDLER_NOT_FOUND)
      end)
  end

  def self.master_routes
    Puppet::Network::HTTP::Route.path(Regexp.new("^#{Puppet::Network::HTTP::MASTER_URL_PREFIX}/")).
      any.
      chain(Puppet::Network::HTTP::API::Master::V3.routes,
            Puppet::Network::HTTP::API::Master::V2.routes,
            Puppet::Network::HTTP::API.not_found)
  end

  def self.ca_routes
    Puppet::Network::HTTP::Route.path(Regexp.new("^#{Puppet::Network::HTTP::CA_URL_PREFIX}/")).
      any.
      chain(Puppet::Network::HTTP::API::CA::V1.routes,
            Puppet::Network::HTTP::API.not_found)
  end
end
