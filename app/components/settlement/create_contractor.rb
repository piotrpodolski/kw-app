module Settlement
  class CreateContractor
    include Dry::Monads::Either::Mixin

    def initialize(repository, form)
      @repository = repository
      @form = form
    end

    def call(raw_inputs:)
      form_outputs = form.call(raw_inputs.to_unsafe_h)
      return Left(form_outputs.messages(full: true)) unless form_outputs.success?

      contract = repository.create_contractor(form_outputs: form_outputs)

      Right(contract)
    end

    private

    attr_reader :repository, :form
  end
end
