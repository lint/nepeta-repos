module Auth
  def authenticate(user)
    token = SecureRandom.alphanumeric(64)
    Session.insert(:token => token, :user_id => user[:id], :ip => request.ip)
    response.set_cookie('sid', token)
  end

  def get_session(r)
    @user = nil
    @session = nil
    if r.cookies.key?('sid')
      @session = Session.first(:token => r.cookies['sid'])

      if @session
        @user = @session.user
      end
    end
  end

  def logout()
    response.delete_cookie('sid')
    session.delete() if @session
  end
  
  def session()
    @session
  end

  def user()
    @user
  end
end