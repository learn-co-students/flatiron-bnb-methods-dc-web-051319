# frozen_string_literal: true

class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, class_name: 'User'
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :check_guest, :available, :same_date?, :date_order

  def check_guest
    errors.add(:guest_id, "can't be in the host") if guest == listing.host
  end

  def available
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

  def same_date?
    errors.add(:checkout, "can't be same date") if checkin == checkout
  end

  def date_order
    if checkin && checkout
      if checkin > checkout
        errors.add(:checkin, "can't be greater than checkoout")
      end
    end
  end

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    duration.to_f * listing.price
  end
end
