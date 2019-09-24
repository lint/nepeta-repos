module Routes
  class OAuth < Base
    route do |r|
      get_session(r)
      
      r.get 'authorize' do
        if r.params.key?('client_id') and r.params.key?('redirect_uri')
          app_id = HASHIDS_APP.decode(r.params['client_id'])

          if !app_id.nil?
            app = App.first(:id => app_id)

            if app
              if not user
                view('auth/login', locals: {redirect: r.fullpath, app: app})
              else
                token = Token.first(:app_id => app[:id], :user_id => user[:id])
                code = SecureRandom.alphanumeric(64)

                if token
                  token.code = code
                  token.save
                  uri = URI.parse(r.params['redirect_uri'])
                  query_arr = URI.decode_www_form(uri.query || '') << ['state', r.params['state']]
                  query_arr = query_arr << ['code', code]
                  uri.query = URI.encode_www_form(query_arr)
                  r.redirect uri.to_s
                else
                  view('oauth/authorize', locals: {app: app, params: r.params})
                end
              end
            end
          end
        end
      end

      r.post 'continue' do
        if user and r.params.key?('client_id') and
          r.params.key?('redirect') and r.params.key?('allow') and
          r.params.key?('state')

          app_id = HASHIDS_APP.decode(r.params['client_id'])

          if !app_id.nil?
            app = App.first(:id => app_id)

            if app
              uri = URI.parse(r.params['redirect'])
              query_arr = URI.decode_www_form(uri.query || '') << ['state', r.params['state']]

              if r.params['allow'] == 'yes'
                token = Token.first(:app_id => app[:id], :user_id => user[:id])
                code = SecureRandom.alphanumeric(64)

                if not token
                  Token.insert(:code => code, :token => SecureRandom.alphanumeric(64), :user_id => user[:id], :app_id => app[:id])
                else
                  token.code = code
                  token.save
                end

                query_arr = query_arr << ['code', code]
              else
                query_arr = query_arr << ['error', 'access_denied']
              end
              uri.query = URI.encode_www_form(query_arr)
              r.redirect uri.to_s
            end
          end
        end
      end

      r.post 'token' do
        response['Content-Type'] = 'application/json'
        if r.params.key?('client_id') and r.params.key?('code') and r.params.key?('client_id') and r.params.key?('client_secret')
          app_id = HASHIDS_APP.decode(r.params['client_id'])

          if !app_id.nil?
            app = App.first(:id => app_id)

            if app and app[:secret] == r.params['client_secret']
              token = Token.first(:code => r.params['code'])

              if token
                token.code = nil
                token.save
                output = {:token_type => 'bearer', :access_token => token[:token]}
                next output.to_json
              else
                output = {:error => 'Invalid code.'}
                next output.to_json
              end
            end
          end
        end
      end
    end
  end
end