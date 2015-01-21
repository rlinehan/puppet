class Puppet::Network::HTTP::API::IndirectionType

  INDIRECTION_TYPE_MAP = {
    "certificate" => :ca,
    "certificate_request" => :ca,
    "certificate_revocation_list" => :ca,
    "certificate_status" => :ca
  }

  def self.master_url_prefix
    "#{Puppet[:master_url_prefix]}/v3"
  end

  def self.ca_url_prefix
    "#{Puppet[:ca_url_prefix]}/v1"
  end

  def self.type_for(indirection)
    INDIRECTION_TYPE_MAP[indirection] || :master
  end

  def self.url_prefix_for(indirection_name)
    case type_for(indirection_name)
    when :ca
      ca_url_prefix
    when :master
      master_url_prefix
    else
      raise ArgumentError, "Not a valid indirection type"
    end
  end
end
