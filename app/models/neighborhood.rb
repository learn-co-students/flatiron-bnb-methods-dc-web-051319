# frozen_string_literal: true

class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(_date1, date2)
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
    all.max_by do |neighborhood|
      listings_count = neighborhood.listings.count
      reservation_count = neighborhood.listings.inject(0) do |sum, listing|
        listing.reservations.count + sum
      end
      if listings_count > 0
        reservation_count / listings_count
      else
        0
      end
    end
  end

  def self.most_res
    all.max_by do |neighborhoood|
      neighborhoood.listings.inject(0) do |sum, n|
        n.reservations.count + sum
      end
    end
  end
end
