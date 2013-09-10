class Rack::Auth::AuthenticationFilter

  def initialize(scopes = 0)
    @required_scopes = get_scopes(scopes)

    # SmD instance used to for expiration checks
    @smd = Rack::Auth::SmD.new
  end

  def before(controller)
    controller.head 401 unless authenticate_request(controller.request)
  end

  def after(controller)
  end

  def authenticate_request(request)
    return false unless request

    token_data = request.env['octanner_auth_user']
    return false unless token_data

    authenticate_scopes(token_data['s']) && authenticate_expires(token_data['e'])
  end

  def authenticate_scopes(scopes = 0)
    @required_scopes & get_scopes(scopes) == @required_scopes
  end

  # Uses SmD date from the token to determine if the token
  # has "expired".  See:  https://npmjs.org/package/smd
  # NOTE: There are some issues when a token date is on the
  # SmD range "boundary"; Tim will resolve those and we'll
  # implement here.
  def authenticate_expires(smd)
    return true if @smd.date(smd) > Time.now
    false
  end

  private

  def get_scopes(scopes)
    if scopes.kind_of? Array
      scopes.reduce( 0, :+ )
    else
      scopes.nil? ? 0 : scopes
    end
  end
end