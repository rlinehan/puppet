require 'spec_helper'

require 'puppet/network/http'

describe Puppet::Network::HTTP::API::V3 do
  let(:response) { Puppet::Network::HTTP::MemoryResponse.new }
  let(:master_url_prefix) { "#{Puppet[:master_url_prefix]}/v3"}
  let(:ca_url_prefix) { "#{Puppet[:ca_url_prefix]}/v1"}
  let(:master_routes) {
    Puppet::Network::HTTP::Route.
        path(Regexp.new(Puppet[:master_url_prefix])).
        any.
        chain(Puppet::Network::HTTP::API::V3.master_routes)
  }

  let(:ca_routes) {
    Puppet::Network::HTTP::Route.
      path(Regexp.new(Puppet[:ca_url_prefix])).
      any.
      chain(Puppet::Network::HTTP::API::V3.ca_routes)
  }

  it "mounts the environments endpoint" do
    request = Puppet::Network::HTTP::Request.from_hash(:path => "#{master_url_prefix}/environments")
    master_routes.process(request, response)

    expect(response.code).to eq(200)
  end

  it "mounts indirected routes" do
    request = Puppet::Network::HTTP::Request.
        from_hash(:path => "#{master_url_prefix}/node/foo",
                  :params => {:environment => "production"},
                  :headers => {"accept" => "text/pson"})
    master_routes.process(request, response)

    expect(response.code).to eq(200)
  end

  it "mounts ca routes" do
    Puppet::SSL::Certificate.indirection.stubs(:find).returns "foo"
    request = Puppet::Network::HTTP::Request.
        from_hash(:path => "#{ca_url_prefix}/certificate/foo",
                  :params => {:environment => "production"},
                  :headers => {"accept" => "s"})
    ca_routes.process(request, response)

    expect(response.code).to eq(200)
  end

  it "responds to unknown paths with a 404" do
    request = Puppet::Network::HTTP::Request.from_hash(:path => "#{master_url_prefix}/unknown")
    master_routes.process(request, response)

    expect(response.code).to eq(404)
    expect(response.body).to match("Not Found: Could not find indirection 'unknown'")
  end
end
