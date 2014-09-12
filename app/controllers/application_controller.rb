class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  before_filter { |controller| session[:restore_url] = request.url unless request.xhr? }
  before_filter { cas_client_sign_in if params[:dev_sign_in] }

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to ENV["CAS_SERVER_URL"] + "?service=#{session[:restore_url]}"
  end

  def current_user
    if session['cas']
      User.find_by(email: session['cas']['user'])
    end
  end

  # TODO: move it to an accounts gem
  def cas_client_sign_in
    render nothing: true, status: :unauthorized
  end
end
