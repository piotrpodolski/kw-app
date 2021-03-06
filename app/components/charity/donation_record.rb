module Charity
  class DonationRecord < ActiveRecord::Base
    self.table_name = 'donations'
    has_one :payment, as: :payable, dependent: :destroy, class_name: 'Db::Payment'
    belongs_to :user, class_name: 'Db::User'

    def payment_type
      :donations
    end

    def description
      "Darowizna na pomoc społeczną rodziny Mariusza Norweckiego"
    end
  end
end
