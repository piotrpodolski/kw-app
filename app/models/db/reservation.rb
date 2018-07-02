class Db::Reservation < ActiveRecord::Base
  include Workflow
  belongs_to :user
  has_many :reservation_items
  has_many :items, through: :reservation_items
  has_one :payment, as: :payable

  default_scope { order('start_date') } 
  scope :not_prepaid, -> { joins(:payment).where.not(payments: { state: 'prepaid' }) }
  scope :not_cash, -> { joins(:payment).where(payments: {cash: false}) }
  scope :cash_prepaid, -> { joins(:payment).where(payments: {cash: true}) }
  scope :not_archived, -> { where.not(state: :archived) }
  scope :archived, -> { where(state: :archived) }
  scope :expire_tomorrow, -> { where(end_date: 1.day.ago.to_date) }
  scope :reserved, -> { where(state: :reserved) }
  scope :holding, -> { where(state: :holding) }
  
  delegate :kw_id, to: :user

  workflow_column :state
  workflow do
    state :reserved do
      event :give, :transitions_to => :holding
      event :archive, :transitions_to => :archived
    end
    state :holding do
      event :archive, :transitions_to => :archived
    end
    state :archived
  end

  def items_display
    items.map{ |i| "#{i.display_name} #{i.rentable_id}" }
  end

  def cost
    items.map(&:cost).reduce(:+)
  end

  def payment_type
    :reservations
  end

  def description
    "Wypożyczenie sprzętu sportowego ##{id} przez #{user.display_name} o nr legitymacji klubowej: #{user.kw_id}"
  end

  def when
    [start_date.strftime("%d"), end_date.strftime("%d/%m/%Y")].join('-')
  end
end
