module Training
  module Supplementary
    class DestroySignUp
      include Dry::Monads::Either::Mixin

      def initialize(repository)
        @repository = repository
      end

      def call(code:)
        course = Training::Supplementary::CourseRecord.find(form_outputs[:course_id])

        sign_up = repository.find_sign_up(code)
        return Left(email: I18n.t('.not_found')) unless sign_up.present?
        return Left(payment: I18n.t('.not_found')) unless sign_up.payment.present?
        Payments::DeletePayment.new(payment: sign_up.payment).delete

        sign_up.destroy
        Right(:success)
      end

      private

      attr_reader :repository
    end
  end
end
