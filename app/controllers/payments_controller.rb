class PaymentsController < ApplicationController
  def index
  end

  def destroy

  end

  def refund
    payment = Db::Payment.find(params[:id])

    result = Payments::Dotpay::GetOperationRequest.new(code: payment.dotpay_id).execute
    result.success do |response|
      res = Payments::Dotpay::RefundPaymentRequest.new(code: JSON.parse(response)["results"][0]["number"]).execute
      res.success do
        return redirect_back(fallback_location: root_path, notice: 'Zwrócono')
      end
      res.dotpay_request_error do
        return redirect_back(fallback_location: root_path, alert: 'Błąd podczas zwrotu!')
      end
    end
    result.dotpay_request_error do
      return redirect_back(fallback_location: root_path, alert: 'Błąd podczas zwrotu!')
    end
  end

  def mark_as_paid
    payment = Db::Payment.find(params[:id])
    if user_signed_in? && (current_user.admin? || current_user.roles.include?('events'))
      payment.update(cash_user_id: current_user.id, cash: true, state: 'prepaid')

      redirect_back(fallback_location: root_path, notice: 'Oznaczono jako zapłacone')
    else
      redirect_back(fallback_location: root_path, alert: 'Nie masz uprawnień')
    end
  end

  def charge
    payment = Db::Payment.find(params[:id])
    if payment.payable.is_a?(Training::Supplementary::SignUpRecord)
      unless payment.payable
        return redirect_to(supplementary_course_path(payment.payable.course.id), alert: 'Twój zapis został usunięty, spróbuj zapisać się ponownie!')
      end
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
