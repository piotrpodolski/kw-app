module Settlement
  class ContractRecord < ActiveRecord::Base
    include Workflow

    self.table_name = 'contracts'
    has_paper_trail
    mount_uploaders :attachments, Settlement::AttachmentUploader
    serialize :attachments, JSON

    enum document_type: [:fv, :work, :service, :bill, :volunteering, :charities, :taxes]
    enum payout_type: [:to_contractor, :return]
    enum group_type: [:kw, :snw, :sww, :stj]
    enum event_type: [:not_event, :other_event, :mjs, :mas, :mo, :kfg]
    enum activity_type: [:courses, :competitions, :other_activity, :maintenance, :supplementary_trainings]
    enum substantive_type: [:salary, :other_substantive, :materials, :equipment, :finantial_costs, :rewards, :printing, :insurance]
    enum area_type: [:marketing, :it, :accomodation, :administration, :reservations, :training, :image, :integration, :associations, :mountain_actions, :general]
    enum financial_type: [:opp_paid, :opp_unpaid]

    belongs_to :acceptor, class_name: 'Db::User', foreign_key: :acceptor_id
    belongs_to :checker, class_name: 'Db::User', foreign_key: :checker_id
    belongs_to :creator, class_name: 'Db::User', foreign_key: :creator_id
    belongs_to :contractor, class_name: 'Settlement::ContractorRecord', foreign_key: :contractor_id

    has_many :contract_events, class_name: 'Settlement::ContractEventsRecord', foreign_key: :contract_id
    has_many :events, class_name: 'Training::Supplementary::CourseRecord', through: :contract_events, foreign_key: :event_id, dependent: :destroy

    has_many :contract_users, class_name: 'Settlement::ContractUsersRecord', foreign_key: :contract_id
    has_many :users, through: :contract_users, foreign_key: :user_id, dependent: :destroy

    has_many :comments, as: :commentable, class_name: 'Messaging::CommentRecord'

    has_many :project_items, as: :accountable, class_name: '::Settlement::ProjectItemRecord'
    has_many :projects, through: :project_items



    workflow_column :state
    workflow do
      state :new do
        event :accept, :transitions_to => :accepted
      end
      state :accepted do
        event :prepayment, :transitions_to => :preclosed
      end
      state :preclosed do
        event :finish, :transitions_to => :closed
      end
      state :closed
    end

    def contractor_name=(id)
      self.contractor_id = id
    end

    attr_reader :contractor_name
  end
end
