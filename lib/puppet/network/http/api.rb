class Puppet::Network::HTTP::API
  def self.not_found
    Puppet::Network::HTTP::Route.
      path(/.*/).
      any(lambda do |req, res|
        raise Puppet::Network::HTTP::Error::HTTPNotFoundError.new("No route for #{req.method} #{req.path}", Puppet::Network::HTTP::Issues::HANDLER_NOT_FOUND)
      end)
  end

  def self.master_routes
    master_prefix = Puppet[:master_url_prefix]
    if !master_prefix.end_with?("/")
      master_prefix = "#{master_prefix}/"
    end
    Puppet::Network::HTTP::Route.path(Regexp.new("^#{master_prefix}")).
      any.
      chain(Puppet::Network::HTTP::API::V3.master_routes,
            Puppet::Network::HTTP::API::V2.routes,
            Puppet::Network::HTTP::API.not_found)
  end

  def self.ca_routes
    ca_prefix = Puppet[:ca_url_prefix]
    if !ca_prefix.end_with?("/")
      ca_prefix = "#{ca_prefix}/"
    end
    Puppet::Network::HTTP::Route.path(Regexp.new("^#{ca_prefix}")).
      any.
      chain(Puppet::Network::HTTP::API::V3.ca_routes,
            Puppet::Network::HTTP::API.not_found)
  end
end
