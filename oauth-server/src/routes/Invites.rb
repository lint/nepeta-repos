module Routes
  class Invites < Base
    route do |r|
      get_session(r)
      
      if not user or user.role != 'admin'
        response.status = 403
        next
      end

      r.post 'new' do
        Invite.insert(:token => SecureRandom.alphanumeric(64), :user_id => user.id)
        r.redirect '/'
      end

      r.is String do |app_id|
        r.post 'delete' do

        end
      end
    end
  end
end