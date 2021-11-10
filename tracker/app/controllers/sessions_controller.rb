class SessionsController < ApplicationController
  def new; end

  def create
    account = Account.find_by(public_id: auth_hash['info']['public_id'])
    session[:account] = account

    redirect_to root_path
  end

  def destroy
    session[:account] = nil

    redirect_to login_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
