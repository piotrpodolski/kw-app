module Training
  module Supplementary
    ManuallySignUpForm = Dry::Validation.Params do
      configure do
        config.messages = :i18n
        config.messages_file = 'app/components/training/errors.yml'
        config.type_specs = true
      end

      required(:email).filled(:str?)
    end
  end
end
