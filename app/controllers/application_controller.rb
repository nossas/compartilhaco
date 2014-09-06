class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  before_filter { cas_client_sign_in if params[:dev_sign_in] }

  def current_user
    if session['cas']
      User.find_by_email(session['cas']['user'])
    end
  end

  # TODO: move it to an accounts gem
  def cas_client_sign_in
    render nothing: true, status: :unauthorized
  end
end
