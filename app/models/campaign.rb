class Campaign < ActiveRecord::Base
  belongs_to :company

  def location
    self.company_location_address + ", " + self.company_location_city + ", " + self.company_location_state + ", "+ self.company_location_zipcode
  end

  def place
    self.company_location_city + ", " + self.company_location_state
  end

  def finished?
    self.offering_terms?
  end
end
