class PaymentsController < ApplicationController
  def index
  end

  def mark_as_paid
    payment = Db::Payment.find(params[:id])
    if user_signed_in? && (current_user.admin? || current_user.roles.include?('events'))
      payment.update(cash: true)

      redirect_back fallback_location: root_path, notice: 'Oznaczono jako zapłacone'
    else
      redirect_back fallback_location: root_path, alert: 'Nie masz uprawnień'
    end
  end

  def charge
    payment = Db::Payment.find(params[:id])
    if payment.payable.is_a?(Training::Supplementary::SignUpRecord)
      if Training::Supplementary::Limiter.new(payment.payable.course).reached?
        return redirect_to(supplementary_course_path(payment.payable.course.id), alert: 'Limit zapisów został wykorzystany!')
      end
    end
    result = Payments::CreatePayment.new(payment: payment).create
    result.success do |payment_url:|
      payment.update(payment_url: payment_url)
      redirect_to payment_url
    end
    result.wrong_payment_url { |message:| redirect_to root_path, alert: message }
    result.dotpay_request_error { |message:| redirect_to root_path, alert: message }
  end
end
