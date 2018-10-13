module Training
  module Activities
    SkiRouteForm = Dry::Validation.Params do
      configure do
        config.messages = :i18n
        config.messages_file = 'app/components/training/errors.yml'
        config.type_specs = true
      end

      required(:name).filled(:str?)
      required(:climbing_date).filled
      required(:rating).filled
    end
  end
end
