class Rack::Auth::AuthenticationFilter

  def initialize(scopes = 0)
    @required_scopes = get_scopes(scopes)
  end


  def before(controller)
    controller.head 401 unless authenticate_request(controller.request)
  end


  def after(controller)
  end


  def authenticate_request(request)
    return false unless request

    user_data = request.env['octanner_auth_user']
    return false unless user_data

    authenticate_scopes user_data['s']
  end


  def authenticate_scopes(scopes = 0)
    @required_scopes & get_scopes(scopes) == @required_scopes
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