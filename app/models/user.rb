class User < ActiveRecord::Base
	before_create :set_authority
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


	has_many :investments
	has_many :companies
	has_many :comments

	has_many :invites

	has_many :liquidate_shares
	has_many :bids

	has_one :investor

	has_many :docusigns
	#Getter
	validates :first_name, presence:true
	validates :last_name, presence:true
	#validates_uniqueness_of :login
	#validates_uniqueness_of :email
	#validates :password, length: { in: 6..20 }
	validates :password, confirmation: true

	def self.from_omniauth(auth)
		pass =  SecureRandom.uuid.gsub(/\-/, '')
	  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
	    user.provider = auth.provider
	    user.uid = auth.uid
	    user.email = auth.info.email
	    user.confirmed = true
	    user.first_name = auth.info.name.split(' ').first
	    user.last_name = auth.info.name.split(' ').second
	    user.authority = 1
	    #user.image_url = auth.info.image
	  end
	end

	def self.Authority
		{
			:Basic => 1,
			:Accredited => 2,
			:Founder => 3,
			:Admin => 4
		}
	end

	def set_authority
		self.authority = 2
	end

	def name
		first_name.capitalize + " " + last_name.capitalize
	end

	def comments_name
		first_name.capitalize + " " + last_name.capitalize.chars.first + "."
	end

	def my_campaign
		if self.companies.any?
			company = self.companies.last
			campaign = company.campaign
			if campaign.submitted?
				company.name
			else
				if company.name
					"Finish #{company.name}"
				else
					"Finish Campaign"
				end
			end
		else
			"Get Funded"
		end
	end

end
