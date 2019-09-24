module Utils
  def provider_name()
    Config.domain
  end

  def hash_app(id)
    HASHIDS_APP.encode(id)
  end
end