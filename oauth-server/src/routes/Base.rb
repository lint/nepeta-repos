module Routes
  class Routes < Roda
    include Utils
    include Auth

    plugin :request_headers
  end

  class Base < Routes
    use Rack::Session::Cookie, :key => 'rack.session', :path => '/', :secret => Config.session_secret
    plugin :cookies, expires: Time.new(Time.now.year + 30,1,1), path: '/'
    plugin :render, template_opts: {:escape_html => true}
    plugin :assets, css: 'app.scss'
    plugin :csrf, :skip => ['POST:/token']
  end
end