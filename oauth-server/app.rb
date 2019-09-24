require 'roda'
require 'sequel'
require 'hashids'
require 'bcrypt'
require 'securerandom'
require 'uri'
require 'json'
require 'yaml'

require_relative 'src/Config'
Config.load(File.join(__dir__, 'config.yml'))

HASHIDS_USER = Hashids.new(Config.hashids_salt_user, Config.hashids_length)
HASHIDS_APP = Hashids.new(Config.hashids_salt_app, Config.hashids_length)

DB = Sequel.sqlite
require_relative 'schema'

Sequel::Model.plugin :timestamps, update_on_create: true
require_relative 'src/models/App'
require_relative 'src/models/User'
require_relative 'src/models/Session'
require_relative 'src/models/Token'
require_relative 'src/models/Invite'
require_relative 'src/models/AppInvite'

require_relative 'src/Auth'
require_relative 'src/Utils'

require_relative 'src/routes/Base'
require_relative 'src/routes/API'
require_relative 'src/routes/Apps'
require_relative 'src/routes/Auth'
require_relative 'src/routes/Invites'
require_relative 'src/routes/OAuth'
require_relative 'src/routes/Users'

User.insert(:username => 'demo', :password => BCrypt::Password.create('demo'), :role => 'admin')
test_app = App.new(:name => 'Test app', :secret => 'XjXiWcfiQpw3NvDQ5YmDqaIIkjW58SHOAsMgQ2Yrp1Db33qFD48iUJCHaXo9STPN', :private => false).save
Token.insert(:code => SecureRandom.alphanumeric(64), :token => SecureRandom.alphanumeric(64), :user_id => 1, :app_id => 1, :role => 'admin')

puts '==== EXAMPLE APP INFO ===='
puts 'Client id: ' + HASHIDS_APP.encode(test_app[:id])
puts 'Client secret: ' + test_app[:secret]
puts '==== END ===='

class AccountsApp < Roda
  include Utils
  include Auth

  use Rack::Session::Cookie, :key => 'rack.session', :path => '/', :secret => Config.session_secret
  plugin :csrf, :skip => ['POST:/oauth/.*']
  plugin :render, template_opts: {:escape_html => true}
  plugin :assets, css: 'app.scss'
  plugin :cookies, expires: Time.new(Time.now.year + 30,1,1), path: '/'
  plugin :request_headers
  plugin :run_handler

  route do |r|
    r.assets

    r.root do
      get_session(r)

      if not user
        r.redirect '/auth/login'
        next
      end

      invites = nil
      users = nil
      apps = nil
      if user.role == 'admin'
        invites = Invite.all()
        users = User.all()
        apps = App.all()
      end
      
      view('dashboard', locals: {invites: invites, users: users, apps: apps})
    end
    
    r.on 'api' do
      r.run Routes::API
    end

    r.on 'app' do
      r.run Routes::Apps
    end

    r.on 'auth' do
      r.run Routes::Auth
    end

    r.on 'invite' do
      r.run Routes::Invites
    end

    r.on 'oauth' do
      r.run Routes::OAuth
    end

    r.on 'user' do
      r.run Routes::Users
    end
  end
end