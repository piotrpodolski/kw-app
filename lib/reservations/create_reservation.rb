require 'results'
require 'reservations/form'

module Reservations
  class CreateReservation
    class << self
      def create(user:, form:)
        return Failure.new(:form_invalid, form: form) unless form.valid?
        if (items_reserved_in_period(form.start_date) & form.item_ids).any?
          return Failure.new(:item_already_reserved)
        end

        reservation = Db::Reservation
          .where(start_date: form.start_date)
          .first_or_initialize(form.attributes)
        reservation.user = user

        new_items = Db::Item.where(id: form.item_ids)
        new_items.each do |item|
          reservation.items.push(item) unless reservation.items.include?(item)
        end

        reservation.build_reservation_payment(cash: true)
        reservation.save
        ReservationMailer.reserve(reservation).deliver_now
        Success.new
      end

      def items_reserved_in_period(start_date)
        Db::Reservation.where(start_date: start_date).map(&:item_ids).flatten.uniq
      end
    end
  end
end
