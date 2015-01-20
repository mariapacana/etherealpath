class GodMessage < ActiveRecord::Base
  belongs_to :mission

  validates :text,
            :mission_id,
            presence: true
  validate :location_is_either_sf_or_east_bay

  private
    def location_is_either_sf_or_east_bay
      return if location.blank?
      if !location.match(/SF|East Bay/)
        errors.add(:location, "Must be SF or East Bay")
      end
    end
end