require 'dry-validation'

module Charity
  DonationForm = Dry::Validation.Schema do
    configure do
      config.messages = :i18n
      config.messages_file = 'app/components/training/errors.yml'
      config.type_specs = true
    end

    required(:cost).filled(:str?)
    optional(:user_id).filled
  end
end
