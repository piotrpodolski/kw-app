require 'i18n'
require 'dry-validation'

module Events
  module Competitions
    module SignUps
      SignUpTeamSingleForm = Dry::Validation.Params do
        configure { config.messages_file = 'app/components/events/competitions/sign_ups/errors.yml' }
        configure { config.messages = :i18n }
        configure { option :competition_id }

        optional(:team_name).maybe(:str?)
        optional(:single).maybe
        required(:participant_name_1).filled(:str?)
        required(:participant_email_1).filled(:str?, format?: /.@.+[.][a-z]{2,}/i)
        optional(:competition_package_type_1_id).filled(:int?)
        optional(:participant_kw_id_1).maybe(:int?)
        required(:participant_gender_1).filled(:int?)
        required(:participant_birth_year_1).filled(:int?, gt?: 1920)
        optional(:tshirt_size_1).maybe(:str?)
        optional(:participant_team_1).maybe(:str?)
        optional(:participant_city_1).maybe(:str?)
        validate(active_kw_id_1: [:participant_kw_id_1, :competition_package_type_1_id]) do |kw_id, package_id|
          if Events::Db::CompetitionPackageTypeRecord.find(package_id).membership?
            ::Membership::Activement.new(user: ::Db::User.find_by(kw_id: kw_id)).active?
          else
            true
          end
        end

        optional(:remarks).maybe(:str?)
        required(:terms_of_service).value(:true?)
      end
    end
  end
end
