class Puppet::Network::HTTP::API::IndirectionType

  INDIRECTION_TYPE_MAP = {
    "certificate" => :ca,
    "certificate_request" => :ca,
    "certificate_revocation_list" => :ca,
    "certificate_status" => :ca
  }

  def self.type_for(indirection)
    INDIRECTION_TYPE_MAP[indirection] || :master
  end
end
