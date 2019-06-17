# frozen_string_literal: true

class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, class_name: 'User'

  validates :rating, presence: true
  validates :description, presence: true
  validate :reservation_exist?, :after_date

  def reservation_exist?
    unless Reservation.exists?(reservation_id)
      errors.add(:reservation_id, 'reservation does not exist')
    end
  end

  def after_date
    if reservation_id && created_at
      if created_at < reservation.checkout
        errors.add(:reservation_id, "can't create review before checkout")
      end
    end
  end
end
