class Business < CorporateEntity
  belongs_to :industry
  has_many :contributions

  def total_contributions
    self.contributions.sum("amount")
  end
end
