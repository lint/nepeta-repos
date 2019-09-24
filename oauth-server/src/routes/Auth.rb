module Routes
  class Auth < Base
    route do |r|
      get_session(r)
      
      r.params.transform_values! { |v| v.strip }

      r.is 'login' do
        if user
          r.redirect '/'
          next
        end
        
        r.get do
          view('auth/login')
        end

        r.post do
          if r.params.key?('username') and r.params.key?('password')
            u = User.first(:username => r.params['username'])

            if u
              password = BCrypt::Password.new(u[:password])

              if password == r.params['password']
                authenticate(u)
                
                if !r.params.key?('redirect')
                  r.redirect '/'
                else
                  r.redirect r.params['redirect']
                end
                next
              end
            end
          end
          view('auth/login', locals: {error: 'Username or password is invalid'})
        end
      end

      r.is 'signup' do
        if user
          r.redirect '/'
          next
        end

        r.get do
          view('auth/signup', locals: {invite_required: !Config.public})
        end

        r.post do
          invite = nil
          if not Config.public
            next view('auth/signup', locals: {error: 'This instance is private and requires an invite.', invite_required: !Config.public}) if not r.params.key?('invite')

            invite = Invite.first(:token => r.params['invite'])
            next view('auth/signup', locals: {error: 'This invite is invalid.', invite_required: !Config.public}) if not invite
          end
      
          if r.params.key?('username') and r.params.key?('password') and r.params.key?('password_confirmation')
            u = User.first(:username => r.params['username'])

            next view('auth/signup', locals: {error: 'This username is already taken.', params: r.params, invite_required: !Config.public}) if u
            next view('auth/signup', locals: {error: 'Passwords don\'t match.', params: r.params, invite_required: !Config.public}) if r.params['password'] != r.params['password_confirmation']
            
            password = BCrypt::Password.create(r.params['password'])
            role = 'user'

            if invite
              role = invite.role
              invite.delete()
            end

            u = User.new(:username => r.params['username'], :password => password, :role => role).save
            authenticate(u)

            r.redirect '/'
            next
          end
          view('auth/signup', locals: {error: 'All fields are required.', params: r.params, invite_required: !Config.public})
        end
      end

      r.on 'logout' do
        logout()
        r.redirect '/'
      end
    end
  end
end