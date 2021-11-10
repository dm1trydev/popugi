require_relative '../../lib/omni_auth/strategies/keeper'

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :keeper, ENV.fetch('AUTH_KEY'), ENV.fetch('AUTH_SECRET'), scope: 'public write', provider_ignores_state: Rails.env.development?
end
