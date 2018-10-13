require 'dry/monads/result'

module Training
  module Supplementary
    class CreateCourse
      include Dry::Monads::Result::Mixin


      def initialize(repository, form)
        @repository = repository
        @form = form
      end

      def call(raw_inputs:)
        form_outputs = form.call(raw_inputs)
        return Failure(form_outputs.messages(full: true)) unless form_outputs.success?

        repository.create(form_outputs: form_outputs)
        Success(:success)
      end

      private

      attr_reader :repository, :form
    end
  end
end
