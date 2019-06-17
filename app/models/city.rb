# frozen_string_literal: true

class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, through: :neighborhoods

  def city_openings(_date1, date2)
    listings.select do |listing|
      arr = listing.reservations.select do |reservation|
        if (reservation.checkin <= date2.to_datetime) && (date2.to_datetime <= reservation.checkout)
          reservation
        end
      end
      listing if arr.count == 0
    end
  end

  def self.highest_ratio_res_to_listings
    all.max_by do |city|
      listings_count = city.listings.count
      reservation_count = city.listings.inject(0) do |sum, listing|
        listing.reservations.count + sum
      end
      reservation_count / listings_count
    end
  end

  def self.most_res
    all.max_by do |city|
      city.listings.inject(0) do |sum, n|
        n.reservations.count + sum
      end
    end
  end
end
