module Routes
  class Apps < Base
    route do |r|
      get_session(r)
      
      if not user
        response.status = 403
        next
      end

      r.is 'new' do
        if user.role != 'admin' and user.role != 'developer'
          response.status = 403
          next
        end

        r.get do
          view('app/new')
        end

        r.post do
          next view('app/new', locals: {error: 'Name is required.'}) if not r.params.key?('name')

          app = App.first({:name => r.params['name']})
          next view('app/new', locals: {error: 'This name is already taken.'}) if app

          app = App.new({:name => r.params['name'], :secret => SecureRandom.alphanumeric(64)}).save
          Token.insert(:code => SecureRandom.alphanumeric(64), :token => SecureRandom.alphanumeric(64), :user_id => user.id, :app_id => app.id, :role => 'admin')

          r.redirect '/app/' + HASHIDS_APP.encode(app.id).to_s
        end
      end

      r.on String do |app_id|
        id = HASHIDS_APP.decode(app_id)
        next if not id

        app = App.first(:id => id)
        next if not app

        token = Token.first(:app_id => app.id, :user_id => user.id)
        next if not token and user.role != 'admin'
        
        r.get do
          view('app/view', locals: {app: app, token: token, client_id: app_id})
        end

        r.post 'regenerate' do
          next if token.role != 'admin' or user.role != 'admin'
          app.secret = SecureRandom.alphanumeric(64)
          app.save
          r.redirect '/app/' + app_id
        end

        r.post 'deauthorize' do
          next if token.role == 'admin'
          token.delete()
          r.redirect '/'
        end
      end
    end
  end
end