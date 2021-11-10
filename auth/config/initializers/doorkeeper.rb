Doorkeeper.configure do
  orm :active_record

  resource_owner_authenticator do
    current_account || redirect_to(new_account_session_url)
  end

  admin_authenticator do
    if current_account
      head :forbidden unless current_account.admin?
    else
      redirect_to new_account_session_path
    end
  end
end
