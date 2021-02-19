module Business
  class SignUpRecord < ActiveRecord::Base
    include Workflow
    self.table_name = 'business_sign_ups'

    has_paper_trail

    validates :rodo, acceptance: true
    validates :rules, acceptance: true
    validates :data, acceptance: true
    validates :name, :phone, :email, presence: true

    belongs_to :user, class_name: 'Db::User', foreign_key: :user_id
    belongs_to :course, class_name: 'Business::CourseRecord', foreign_key: :course_id

    has_many :emails, as: :mailable, class_name: 'EmailCenter::EmailRecord', dependent: :destroy
    has_many :comments, as: :commentable, class_name: 'Messaging::CommentRecord'
    has_many :payments, as: :payable, dependent: :destroy, class_name: 'Db::Payment'

    def payment_type
      course.payment_type
    end

    def start_date
      return Time.current unless course && course.start_date
      return Time.current unless course.start_date

      course.start_date
    end

    workflow_column :state
    workflow do
      state :new do
        event :accept, transitions_to: :accepted
      end
      state :accepted
    end

    def description
      "Kurs Szkoły Alpinizmu: #{course.name} - Opłata od #{name}"
    end
  end
end