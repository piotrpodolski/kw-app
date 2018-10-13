module Training
  module Supplementary
    CreateCourseForm = Dry::Validation.Params do
      configure do
        config.messages = :i18n
        config.messages_file = 'app/components/training/errors.yml'
        config.type_specs = true
      end

      required(:name).filled(:str?)
      required(:slug).filled(:str?)
      required(:place).filled(:str?)
      optional(:organizator_id).maybe
    end
  end
end
