class Booking < ApplicationRecord
    belongs_to :user
    belongs_to :property

    scope :overlaps_date, -> (date) { where("'#{date}' BETWEEN start_date AND end_date") }
    scope :within_date_range, -> (start_on, end_on) do
      where("(start_date BETWEEN '#{start_on}' AND '#{end_on}') AND end_date BETWEEN '#{start_on}' AND '#{end_on}'")
    end
    scope :clashes_with, -> (start_on, end_on) do
      within_date_range(start_on, end_on)
        .or(overlaps_date(start_on))
        .or(overlaps_date(end_on))
    end
end
