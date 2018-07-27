module Training
  module Supplementary
    class ManuallySignUp
      include Dry::Monads::Either::Mixin

      def initialize(repository, form)
        @repository = repository
        @form = form
      end

      def call(raw_inputs:)
        form_outputs = form.call(raw_inputs)
        return Left(form_outputs.messages(full: true)) unless form_outputs.success?

        course = Training::Supplementary::CourseRecord.find(form_outputs[:course_id])
        if form_outputs[:email].present?
          user = ::Db::User.find_by(email: form_outputs[:email])
          return Left(email: 'Nie znaleziono użytkownika, sprawdź e-mail!') if user.nil?
          fee = ::Db::Membership::Fee.find_by(kw_id: user.kw_id, year: Date.today.year)

          if course.last_fee_paid
            if fee.present?
              return Left(fee: I18n.t('.not_last_fee')) if !fee.payment.paid?
            else
              return Left(fee: I18n.t('.not_last_fee'))
            end
          end
        end
        return Left(email: I18n.t('.email_not_unique')) if Training::Supplementary::SignUpRecord.exists?(course_id: form_outputs[:course_id], email: form_outputs[:email])
        sign_up = repository.sign_up!(
          course_id: form_outputs[:course_id],
          email: form_outputs[:email],
          user_id: user.id
        )
        Training::Supplementary::SignUpMailer.sign_up(sign_up.id).deliver_later
        Right(:success)
      end

      private

      attr_reader :repository, :form
    end
  end
end