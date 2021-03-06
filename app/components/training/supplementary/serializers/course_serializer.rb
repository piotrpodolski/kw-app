module Training
  module Supplementary
    module Serializers
      class CourseSerializer < ActiveModel::Serializer
        attributes :id, :name, :place, :start_date,
          :end_date, :application_date, :slug, :kind, :limit,
          :end_application_date, :category

        belongs_to :organizer, serializer: UserManagement::UserSerializer
      end
    end
  end
end
