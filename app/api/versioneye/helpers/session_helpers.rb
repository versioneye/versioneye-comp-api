module SessionHelpers


  def authorized?
    @api_key = header['api_key']
    @api_key = params[:api_key] if @api_key.to_s.empty?
    cookies[:api_key] = @api_key if @api_key
    @current_user = current_user()
    if @current_user.nil?
      error! "Request not authorized.", 401
    end
    @current_user
  end


  def authorize( token )
    @current_user = User.authenticate_with_apikey( token )
    if @current_user.nil?
      error! "API token not valid.", 401
    end
    cookies[:api_key] = token
    @current_user
  end


  def current_user
    cookie_token  = cookies[:api_key]
    @current_user = authorize( cookie_token ) if cookie_token
    @current_user
  end


  def github_connected?( user )
    return true if user.github_account_connected?
    error! "Github account is not connected. Check your settings on https://www.versioneye.com/settings/connect", 401
    false
  end


  def clear_session
    cookies[:api_key] = nil
    cookies.delete :api_key
    @current_user = nil
  end


  def fetch_api_key
    api_key = header['api_key']
    api_key = params[:api_key]  if api_key.to_s.empty?
    api_key = request[:api_key] if api_key.to_s.empty?
    api_key = request.cookies["api_key"] if api_key.to_s.empty?
    api_key = cookies[:api_key] if api_key.to_s.empty?
    api_key
  end


  def fetch_api
    api_key = fetch_api_key
    Api.where(:api_key => api_key).first
  end


  def remote_ip_address
    ip = env['REMOTE_ADDR']
    ip = env['HTTP_X_REAL_IP'] if !env['HTTP_X_REAL_IP'].to_s.empty?
    ip
  end


  def http_method_type
    method = "GET"
    method = "POST" if request.post?
    method
  end


  def fetch_protocol
    protocol = "http://"
    protocol = "https://" if request.ssl?
    protocol
  end


  def new_token
    length = 20
    length = (length / 2.0).round
    length = 1 if length < 1
    SecureRandom.hex(length)
  end


  def rate_limit
    return if Rails.env.enterprise? == true

    api   = fetch_api
    ip    = remote_ip_address

    tunit = Time.now - 1.hour
    calls_last_hour = ApiCall.where(:created_at.gt => tunit, :ip => ip).count

    if api.nil?
      if calls_last_hour.to_i >= 5
        error! "API rate limit exceeded. With an API key you can extend your rate limit. Sign up for free and get an API key!", 403
        return
      end
    else
      rate_limit = 50
      rate_limit = api.rate_limit if api && api.respond_to?(:rate_limit)
      if calls_last_hour.to_i >= rate_limit.to_i
        error! "API rate limit exceeded. Write an email to support@versioneye.com if you need a higher rate limit. Used API Key: #{api.api_key}", 403
        return
      end
    end
  end


  def track_apikey
    api_key  = fetch_api_key
    user_api = fetch_api
    user     = user_api.user if user_api
    method   = http_method_type
    protocol = fetch_protocol
    ip       = remote_ip_address

    call_data = {
      fullpath: "#{protocol}#{request.host_with_port}#{request.fullpath}",
      http_method: method,
      ip:       ip,
      api_key:  api_key,
      user_id:  (user.nil?) ? nil : user.id
    }
    new_api_call =  ApiCall.new call_data
    new_api_call.save
  rescue => e
    p "ERROR in track_apikey - #{e.message}"
    e.backtrace.each do |message|
      p " - #{message}"
    end
  end


end
