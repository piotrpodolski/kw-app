require 'i18n'
require 'dry-validation'

module Settlement
  NewContractForm = Dry::Validation.Params do
    configure { config.messages_file = 'app/components/settlement/errors.yml' }
    configure { config.messages = :i18n }

    required(:title).filled(:str?)
    required(:cost).filled(:float?)
    required(:document_type).filled
    required(:payout_type).filled
    required(:document_date).filled(:str?)
    required(:description).maybe(:str?)
    optional(:attachments).maybe
    optional(:group_type).maybe
    optional(:acceptor_id).maybe
    optional(:substantive_type).maybe
    optional(:state).maybe
    optional(:financial_type).maybe
    optional(:period_date).maybe
    required(:user_ids).each(:str?)
    required(:event_ids).each(:str?)
    required(:contractor_id).filled(:int?)
    optional(:event_id).maybe
  end
end
