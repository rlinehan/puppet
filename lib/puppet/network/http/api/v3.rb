class Puppet::Network::HTTP::API::V3
  require 'puppet/network/http/api/v3/authorization'
  require 'puppet/network/http/api/v3/environments'
  require 'puppet/network/http/api/v3/indirected_routes'

  AUTHZ = Authorization.new

  INDIRECTED = Puppet::Network::HTTP::Route.
      path(/.*/).
      any(Puppet::Network::HTTP::API::V3::IndirectedRoutes.new)

  ENVIRONMENTS = Puppet::Network::HTTP::Route.
      path(%r{^/environments$}).get(AUTHZ.wrap do
    Environments.new(Puppet.lookup(:environments))
  end)

  def self.master_routes
    Puppet::Network::HTTP::Route.path(%r{/v3}).
        any.
        chain(ENVIRONMENTS, INDIRECTED)
  end

  def self.ca_routes
    Puppet::Network::HTTP::Route.path(%r{/v1}).any.chain(INDIRECTED)
  end
end
