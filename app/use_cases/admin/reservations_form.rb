require 'active_model'

module Admin
  class ReservationsForm
    include ActiveModel::Model
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks

    attr_accessor :kw_id, :start_date, :end_date, :description

    validates :kw_id, presence: { message: 'nie moze byc pusty'}

    def params
      HashWithIndifferentAccess.new(
        user_id: user.id,
        start_date: start_date,
        end_date: end_date,
        description: description
      )
    end

    def user
      Db::User.find_by(kw_id: kw_id)
    end
  end
end
