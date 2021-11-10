class ApplicationController < ActionController::Base
  private

  attr_reader :current_account

  helper_method :current_account

  def authenticate!
    if session[:account].blank?
      @current_account = nil
      return redirect_to(login_path)
    end
    return if @current_account

    @current_account = Account.find_by(public_id: session[:account]['public_id'])
  end
end
