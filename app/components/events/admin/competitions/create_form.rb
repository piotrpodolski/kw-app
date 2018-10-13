require 'dry-validation'

module Events
  module Admin
    module Competitions
      CreateForm = Dry::Validation.Schema do
        required(:name).filled(:str?)
        required(:email_text).filled(:str?)
        required(:edition_sym).filled(:str?)
      end
    end
  end
end
