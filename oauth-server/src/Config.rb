module Config
  def self.load(file)
    @config = YAML::load_file(file)
  end
    
  def self.domain
    @config['config']['domain']
  end

  def self.public
    @config['config']['public']
  end

  def self.session_secret
    @config['config']['session']['secret']
  end

  def self.hashids_salt_app
    @config['config']['hashids']['salt']['app']
  end

  def self.hashids_salt_user
    @config['config']['hashids']['salt']['user']
  end

  def self.hashids_length
    @config['config']['hashids']['length']
  end
end