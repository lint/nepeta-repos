module Routes
  class API < Routes
    route do |r|
      token = nil

      next if not r.headers['Authorization']
      token = Token.first(:token => r.headers['Authorization'].gsub('Bearer ', '').strip)
      next if not token

      r.get 'user' do
        response['Content-Type'] = 'application/json'
        { username: token.user.username, id: HASHIDS_USER.encode(token.user.id) }.to_json
      end
    end
  end
end