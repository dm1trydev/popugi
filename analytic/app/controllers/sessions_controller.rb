class SessionsController < ApplicationController
  VALID_ROLES = %w[admin].freeze

  def new; end

  def create
    account = Account.find_by(public_id: auth_hash['info']['public_id'])

    if account && VALID_ROLES.include?(account.role)
      session[:account] = account

      redirect_to root_path
    else
      redirect_to login_path, alert: 'Incorrect role'
    end
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
