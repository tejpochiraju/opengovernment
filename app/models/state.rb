class State < Place
  set_table_name 'states'

  has_many :districts
  has_many :addresses
  has_one :legislature

  named_scope :supported, :conditions => ["launch_date < ?", Time.now]
  named_scope :pending, :conditions => ["launch_date >= ?", Time.now]
  named_scope :unsupported, :conditions => {:launch_date => nil}
  has_many :current_senators, :through => :state_roles, :class_name => 'Person', :source => :person, :conditions => Role::CURRENT
  has_many :state_roles, :foreign_key => 'state_id', :class_name => 'Role'

  # Which states are we importing data for?
  named_scope :loadable, :conditions => {:abbrev => ['CA', 'TX']}
  # this could be:
  # named_scope :loadable, :conditions => ["launch_date is not null"]

  validates_uniqueness_of :fips_code, :allow_nil => true
  validates_presence_of :name, :abbrev
  validates_inclusion_of :unicameral, :in => [true, false]
  has_many :subscriptions

  class << self
    def find_by_param(param)
      find_by_name(param.titleize)
    end
  end
  def to_param
    "#{name.parameterize}"
  end

  def unsupported?
    launch_date.blank?
  end

  def supported?
    !unsupported? && (launch_date < Time.now)
  end

  def pending?
    !unsupported? && (launch_date >= Time.now)
  end

  def region_code
    "US-#{self.abbrev}"
  end
end
