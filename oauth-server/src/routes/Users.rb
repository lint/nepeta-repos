module Routes
  class Users < Base
    route do |r|
      get_session(r)
      
      if not user or user.role != 'admin'
        response.status = 403
        next
      end
    end
  end
end