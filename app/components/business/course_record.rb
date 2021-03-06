module Business
  class CourseRecord < ActiveRecord::Base
    include Workflow
    include ActionView::Helpers::AssetTagHelper
    extend FriendlyId
    self.table_name = 'business_courses'
    has_paper_trail

    has_many :comments, as: :commentable, class_name: 'Messaging::CommentRecord'
    belongs_to :instructor, class_name: '::Business::InstructorRecord', foreign_key: :instructor_id
    belongs_to :coordinator, class_name: '::Db::User', foreign_key: :coordinator_id
    belongs_to :event, class_name: 'Training::Supplementary::CourseRecord', foreign_key: :event_id, dependent: :destroy

    validates :seats, numericality: { greater_than_or_equal_to: 0, message: 'Minimum to 0' }
    validates :max_seats, presence: true
    validates :sign_up_url, presence: true
    validates :activity_type, presence: true
    validate :max_seats_size

    friendly_id :slug_candidates, use: :slugged

    enum activity_type: [
      :winter_abc, :winter_tourist_1, :winter_tourist_2,
      :skitour_1, :skitour_2, :skitour_3, :skitour_avalanche, :skitour_avalanche_2,
      :skitour_glacier, :georgia, :norway, :skialp,
      :climbing_1, :climbing_2, :full_climbing, :summer_tatra, :club_climbing,
      :winter_tatra_1, :winter_tatra_2, :ice_1, :ice_2,
      :piste_1, :piste_2, :piste_3, :piste_7, :piste_4, :piste_5, :piste_6,
      :cave, :tatra_traverse
    ]

    def name
      I18n.t("activerecord.attributes.#{Business::CourseRecord.model_name.i18n_key}.activity_types.#{activity_type}")
    end

    def sign_ups_count
      if event_id
        Training::Supplementary::Limiter.new(event).sum
      else
        seats
      end
    end

    def event_url
      if event_id
        "/wydarzenia/#{event.slug}"
      else
        sign_up_url
      end
    end

    def slug_candidates
      [
        [:starts_at, :name]
      ]
    end

    workflow_column :state
    workflow do
      state :draft do
        event :open, :transitions_to => :ready
      end
      state :ready
    end

    def max_seats_size
      if max_seats.present?
        if self.seats > self.max_seats
          errors.add(:seats, 'Przekroczono limit miejsc')
        end
      end
    end

    def self.activity_type_attributes_for_select
      activity_types.map do |activity_type, _|
        [I18n.t("activerecord.attributes.#{model_name.i18n_key}.activity_types.#{activity_type}"), activity_type]
      end
    end

    def activity_url
      case activity_type.to_sym
      when :winter_abc
        'https://szkolaalpinizmu.pl/turystyka/zimowe-abc/'
      when :winter_tourist_1
        'https://szkolaalpinizmu.pl/turystyka/turystyka-zimowa-ist/'
      when :winter_tourist_2
        'https://szkolaalpinizmu.pl/turystyka/turystyka-zimowa-iist/'
      when :skitour_1
        'https://szkolaalpinizmu.pl/narty/kursy-skiturowe/kurs-skiturowy-i-stopnia/'
      when :skitour_2
        'https://szkolaalpinizmu.pl/narty/kursy-skiturowe/kurs-skiturowy-ii-stopnia/'
      when :skitour_3
        'https://szkolaalpinizmu.pl/narty/kursy-skiturowe/kurs-narciarstwa-wysokogorskiego/'
      when :skitour_avalanche
        'https://szkolaalpinizmu.pl/narty/kurs-skiturowo-lawinowy'
      when :skitour_avalanche_2
        'https://szkolaalpinizmu.pl/narty/kursy-skiturowe/kurs-skiturowo-lawinowy-ii-stopnia/'
      when :skitour_glacier
        'https://szkolaalpinizmu.pl/narty/kursy-skiturowe/kurs-skiturowo-lodowcowy/'
      when :climbing_1
        'https://szkolaalpinizmu.pl/wspinanie/wspinaczka-skalna/drogi-ubezpieczone/'
      when :climbing_2
        'https://szkolaalpinizmu.pl/wspinanie/wspinaczka-skalna/kurs-na-wlasnej/'
      when :full_climbing
        'https://szkolaalpinizmu.pl/wspinanie/wspinaczka-skalna/pelny-kurs-wspinaczki/'
      when :club_climbing
        'https://szkolaalpinizmu.pl/wspinanie/wspinaczka-skalna/klubowy-kurs-wspinaczki/'
      when :summer_tatra
        'https://szkolaalpinizmu.pl/wspinanie/taternictwo/kurs-taternicki-letni/'
      when :winter_tatra_1
        'https://szkolaalpinizmu.pl/wspinanie/taternictwo/zimowy-i-stopnia/'
      when :winter_tatra_2
        'https://szkolaalpinizmu.pl/wspinanie/taternictwo/zimowy-ii-stopnia/'
      when :ice_1
        'https://szkolaalpinizmu.pl/wspinanie/wspinaczka-lodowa/'
      when :ice_2
        'https://szkolaalpinizmu.pl/wspinanie/wspinaczka-lodowa/'
      when :cave
        'https://szkolaalpinizmu.pl/jaskinie/'
      when :piste_1
        'https://szkolaalpinizmu.pl/narty/szkolenia-stokowe/'
      when :piste_7
        'https://szkolaalpinizmu.pl/narty/szkolenia-stokowe/'
      when :piste_2
        'https://szkolaalpinizmu.pl/narty/szkolenia-stokowe/'
      when :piste_3
        'https://szkolaalpinizmu.pl/narty/szkolenia-stokowe/'
      when :piste_4
        'https://szkolaalpinizmu.pl/narty/szkolenia-stokowe/'
      when :piste_5
        'https://szkolaalpinizmu.pl/narty/szkolenia-stokowe/'
      when :piste_6
        'https://szkolaalpinizmu.pl/narty/szkolenia-stokowe/'
      when :georgia
        'https://szkolaalpinizmu.pl/narty/kursy-skiturowe/gruzja-gorna-swanetia/'
      when :norway
        'https://szkolaalpinizmu.pl/narty/kursy-skiturowe/oboz-skiturowy-w-norwegii/'
      when :tatra_traverse
        'https://szkolaalpinizmu.pl/narty/kursy-skiturowe/tatrzanskie-przelecze-trawers/'
      when :skialp
        'https://szkolaalpinizmu.pl/narty'
      else
        'https://szkolaalpinizmu.pl/o-nas/klub-i-szkola/'
      end
    end

    def logo
      case activity_type.to_sym
      when :winter_abc, :winter_tourist_1, :winter_tourist_2
        'kw.png'
      when :skitour_1, :skitour_2, :skitour_3, :skitour_avalanche, :skitour_avalanche_2, :piste_1, :piste_2, :piste_3, :piste_4, :piste_5, :piste_6, :skitour_glacier, :piste_7, :tatra_traverse, :georgia, :norway, :skialp
        'snw.png'
      when :climbing_1, :climbing_2, :full_climbing, :summer_tatra, :club_climbing
        'sww.png'
      when :winter_tatra_1, :winter_tatra_2, :ice_1, :ice_2
        'sww.png'
      when :cave
        'stj.png'
      else
        'kw.png'
      end
    end

    def as_json(options={})
      super.merge(
        activity_url: activity_url,
        logo: logo,
        display_name: I18n.t("activerecord.attributes.#{model_name.i18n_key}.activity_types.#{activity_type}"),
        free_seats: max_seats ? max_seats - sign_ups_count : 0,
        sign_up_url: event_url
      )
    end
  end
end
