require 'dry-struct'

module Types
  include Dry::Types.module
end

module Events
  class SignUp < Dry::Struct
    constructor_type :strict

    attribute :id, Types::Strict::Int
    attribute :competition_id, Types::Strict::Int
    attribute :participant_name_1, Types::Strict::String
    attribute :participant_name_2, Types::Strict::String.optional
    attribute :participant_email_1, Types::Strict::String.optional
    attribute :participant_email_2, Types::Strict::String.optional
    attribute :participant_birth_year_1, Types::Strict::Int.optional
    attribute :participant_birth_year_2, Types::Strict::Int.optional
    attribute :participant_city_1, Types::Strict::String.optional
    attribute :participant_city_2, Types::Strict::String.optional
    attribute :participant_team_1, Types::Strict::String.optional
    attribute :participant_team_2, Types::Strict::String.optional
    attribute :participant_gender_1, Types::Strict::String.optional
    attribute :participant_gender_2, Types::Strict::String.optional
    attribute :remarks, Types::Strict::String.optional
    attribute :terms_of_service, Types::Strict::Bool

    class << self
      def from_record(record)
        new(
          id: record.id,
          competition_id: record.competition_record_id,
          participant_name_1: record.participant_name_1,
          participant_name_2: record.participant_name_2,
          participant_email_1: record.participant_email_1,
          participant_email_2: record.participant_email_2,
          participant_birth_year_1: record.participant_birth_year_1,
          participant_birth_year_2: record.participant_birth_year_2,
          participant_city_1: record.participant_city_1,
          participant_city_2: record.participant_city_2,
          participant_team_1: record.participant_team_1,
          participant_team_2: record.participant_team_2,
          participant_gender_1: record.participant_gender_1,
          participant_gender_2: record.participant_gender_2,
          remarks: record.remarks,
          terms_of_service: record.terms_of_service
        )
      end
    end
  end
end
