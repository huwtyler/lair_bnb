class Property < ApplicationRecord
  belongs_to :user
  has_many :facilities
  has_many :reviews
  has_many :bookings
  has_many :bookmarks
  has_many :images

  validates :name, presence: true, length: { maximum: 140 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :status, presence: true, length: { maximum: 140 }, inclusion: {in: ['Live', 'Draft', 'Inactive']}
  validates :base_price, presence: true, numericality: { greater_than: 0, less_than: 1000000 }
  validates :cleaning_fee, presence: true, numericality: { greater_than: 0, less_than: 100 }

  def capacity
    self.facilities.sum(:capacity)
  end

  # This call MUST be able to be done as a single query rather than 6
  def average_rating
    # ((self.reviews.sum(:cleanliness_rating).to_f) + (self.reviews.sum(:host_rating).to_f) + (self.reviews.sum(:location_rating).to_f) + (self.reviews.sum(:check_in_rating).to_f) + (self.reviews.sum(:value_rating).to_f))  / self.reviews.count / 5
    self.reviews.pluck(Arel.sql("(SUM(cleanliness_rating) + SUM(host_rating) + SUM(location_rating) + SUM(check_in_rating) + SUM(value_rating)) / COUNT(*)")).first / 5
  end

  def self.search(search)
    if search
      country = Property.find_by(country: search)
      if country
        self.where(country: country.country)
      else
        @properties = Property.all
      end
    else
      @properties = Property.all
    end
  end

  def total_cost(sd, ed)
    ((ed.to_date - sd.to_date).to_i + 1) * self.base_price
  end

  def bookmarked?(user_id, property_id)
    self.bookmarks.where(user_id: user_id, property_id: property_id).any?
  end

  def available?(start_date, end_date)
    bookings.clashes_with(start_date, end_date).none?
  end
end
