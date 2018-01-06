require 'dry-validation'

module Events
  module Competitions
    module SignUps
      class CreateForm < Dry::Validation::Schema::Form
        define! do
          required(:participant_name_1).filled(:str?)
          required(:terms_of_service).filled(eql?: '1')
        end
      end
    end
  end
end
