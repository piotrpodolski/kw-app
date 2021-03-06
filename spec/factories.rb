def load_fixture(fixture)
  path = File.join(%w(spec fixtures) << (fixture + '.json'))
  file = File.read(path)
  ActiveSupport::JSON.decode(file)[fixture]
end

module Factories
  class User
    def self.create!(attrs = {})
      Db::User.create!(load_fixture('users')[attrs.fetch('id', 1) - 1].merge(attrs))
    end
  end

  class Item
    def self.create!(attrs = {})
      Db::Item.create!(load_fixture('items')[attrs.fetch('id', 1) - 1].merge(attrs))
    end

    def self.create_all!
      load_fixture('items').each do |item_json|
        Db::Item.create!(item_json)
      end
      Db::Item.all
    end
  end

  class Reservation
    def self.create!(attrs = {})
      Db::Reservation.create!(load_fixture('reservations')[attrs.fetch('id', 1) - 1].merge(attrs))
    end

    def self.build_form(attrs = {})
      ::Reservations::Form.new({
        start_date: '2016-08-18',
        end_date: '2016-08-25',
        item_ids: [1]
      }.merge(attrs))
    end
  end

  class Payment
    def self.create!(attrs = {})
      Db::Payment.create!(load_fixture('payments')[attrs.fetch('id', 1) - 1].merge(attrs))
    end
  end

  class Order
    def self.create!(attrs = {})
      Db::Order.create!(load_fixture('orders')[attrs.fetch('id', 1) - 1].merge(attrs))
    end
  end

  class Profile
    def self.create!(attrs = {})
      profile = Db::Profile.create!(load_fixture('profiles')[attrs.fetch('id', 1) - 1].merge(attrs))
    end

    def self.build_form(attrs = {})
      ::UserManagement::ProfileForm.new(
        load_fixture('profiles')[0].merge(attrs)
      )
    end
  end

  module Membership
    class Fee
      def self.create!(attrs = {})
        fee = Db::Membership::Fee.create!(load_fixture('membership_fees')[attrs.fetch('id', 1) - 1].merge(attrs.except(:state, :cash)))
        fee.create_payment(dotpay_id: SecureRandom.hex(13), cash: attrs.fetch(:cash, false), state: attrs.fetch(:state, 'prepaid'))
      end

      def self.mass_create!(range: (1..20), years: [2013, 2014, 2015], cash: true, state: 'prepaid')
        range.step(1) do |i|
          Factories::Membership::Fee.create!(state: state, cash: cash, year: years.sample, kw_id: i)
        end
      end
    end
  end
end
