module Reservations
  UpdateItemsForm = Dry::Validation.Params do
    configure do
      config.messages = :i18n
      config.messages_file = 'app/components/training/errors.yml'
      config.type_specs = true
    end

    required(:id).filled(:str?)
    required(:items_ids).filled(:str?)
  end
end
