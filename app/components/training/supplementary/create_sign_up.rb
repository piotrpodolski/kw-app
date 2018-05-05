module Training
  module Supplementary
    class CreateSignUp
      include Dry::Monads::Either::Mixin

      def initialize(repository, form)
        @repository = repository
        @form = form
      end

      def call(raw_inputs:)
        form_outputs = form.call(raw_inputs)
        return Left(form_outputs.messages(full: true)) unless form_outputs.success?

        course = Training::Supplementary::CourseRecord.find(form_outputs[:course_id])
        return Left(course_id:  I18n.t('.closed_or_open')) if course.open
        return Left(course_id:  I18n.t('.limit_exceded')) if course.limit > 0 && course.sign_ups.count >= course.limit
        if form_outputs[:user_id].present?
          user = ::Db::User.find(form_outputs[:user_id])
          fee = ::Db::Membership::Fee.find_by(kw_id: user.kw_id, year: Date.today.year)
          if course.last_fee_paid
            Left(fee: I18n.t('.not_last_fee')) if !fee&.payment&.paid?
          end
        end
        return Left(email: I18n.t('.email_not_unique')) if Training::Supplementary::SignUpRecord.exists?(course_id: form_outputs[:course_id], email: form_outputs[:email])
        repository.sign_up!(
          course_id: form_outputs[:course_id],
          email: form_outputs[:email],
          user_id: form_outputs[:user_id]
        )
        Right(:success)
      end

      private

      attr_reader :repository, :form
    end
  end
end