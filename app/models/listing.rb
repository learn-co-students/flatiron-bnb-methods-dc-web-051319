# frozen_string_literal: true

class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, class_name: 'User'
  has_many :reservations
  has_many :reviews, through: :reservations
  has_many :guests, class_name: 'User', through: :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true

  after_create :change_host_status
  after_destroy :user_host_after_destroy

  def change_host_status
    @user = User.find(host_id)
    @user.update(host: true)
  end

  def user_host_after_destroy
    @user = User.find(host_id)
    @user.update(host: false) if @user.listings.count == 0
  end

  def average_review_rating
    reviews.inject(0) do |sum, review|
      sum + review.rating.to_f
    end / reviews.count.to_f
  end
end
