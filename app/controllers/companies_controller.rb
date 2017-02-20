class CompaniesController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show, :company_profile ]
	before_action :verify, except: [:index, :company_profile, :show]
	before_action :admin_check, only: [:new, :edit, :make_team, :make_profile]
	before_action :set_company, only: [:company_profile, :edit_profile, :update, :make_profile, :remove_company, :show, :join_waitlist ]
	before_action :check_company_accreditation, only: [:show, :company_profile]

	def index
		@companies = Company.all_accredited
		@funded_companies = Company.all_funded
	end

	def company_profile
		if params[:id] != nil
			@id = params[:id]
			@financial_details = @company.financial_detail
			@progress = @company.invested_amount / @company.goal_amount rescue 0
			@comments = @company.comments
			@members = @company.founders.order(:position)
			@section = @company.sections.first
		else
			redirect_to "/companies"
		end
	end

	def show
		if params[:id] != nil
			@id = params[:id]
			@financial_details = @company.financial_detail
			@progress = @company.invested_amount / @company.goal_amount rescue 0
			@comments = @company.comments
			@members = @company.founders.order(:position)
			@section = @company.sections.first
		else
			redirect_to "/companies"
		end
	end

	def edit_profile
		if current_user == nil || current_user.authority < User.Authority[:Admin]
			redirect_to url_for(:controller => 'home', :action => 'unauthorized')
		end
	end

	def update
		if @company.update(company_params)
			redirect_to company_path(@company)
		else
			@error_update = ""
			@company.errors.full_messages.each do |error|
				@error_update = @error_update + error + ". "
			end
			flash[:problem_update] = @error_update
			redirect_to :controller => 'companies', :action => 'edit_profile', :id => params[:id]
		end
	end

	def new
		redirect_to funding_goal_path
		@company = Company.new
	end

	def create
		@company = Company.new(company_params)
		if @company.save
			@company.campaign = Campaign.create
			@company.sections << Section.new
			redirect_to "/companies"
		else
			@error_message = ""
			@company.errors.full_messages.each do |error|
				@error_message = @error_message + error + ". "
			end
			flash[:message] = @error_message
			redirect_to "/companies/new"
		end
	end

	def edit
		@companies = Company.all
	end

# can be refactored
	def action
		@my_company = Company.find_by(id: params[:id])
		if @my_company == nil
			@message = ""
			@message = "No company with that ID exists. Please create the company first."
			flash[:fail] = @message
			redirect_to url_for(:controller => 'companies', :action => 'edit')
		elsif params[:id] != nil && params[:desired_action] == "1"
			redirect_to url_for(:controller => 'companies', :action => 'make_team', :id => params[:id])
		elsif params[:id] != nil && params[:desired_action] == "2"
			redirect_to url_for(:controller => 'companies', :action => 'make_profile', :id => params[:id])
		end
	end

	def make_team
		@founder = Founder.new
		@companies = Company.all
	end

	def add_team_member
		@founder = Founder.new(founder_params)
		if @founder.save
			redirect_to "/companies"
		else
			redirect_to "/companies/make_team"
		end
	end

	def make_profile
		@section = @company.sections.first
	end

	def submit_profile
		@company = Company.find(params[:section][:id])
		@section = @company.sections.first

		if @section.update(section_params)
			redirect_to "/companies"
		else
			@error_message3 = ""
			section.errors.full_messages.each do |error|
				@error_message3 = @error_message3 + error + ". "
			end
			flash[:problem] = @error_message3
			redirect_to "/companies/make_profile/#{@company.id}"
		end
	end

	def remove_company
    	@company.destroy
   		redirect_to "/companies"
	end

	def remove_founder
    	@founder = Founder.find(params[:id])
    	@company = @founder.company
    	@founder.destroy
    	redirect_to company_path(@company)
 	end

	def join_waitlist
	end

	def join_waitlist_send_email
		company_name = params[:company_name]
		@name = params[:name]
		@email = params[:email]
		@phone = params[:phone]
		@message = params[:message]
		Guest.create(email: params[:email], company: company_name, user_id: current_user.id)
		ContactMailer.contact_us_email(@name, @email, @phone, @message).deliver
		flash[:thank_you_notice] = 'Thank you'
		redirect_to "/join_waitlist_thank_you"
	end

	def join_waitlist_thank_you
	end

	def company_not_accretited
	end

	def accept_company
		user = User.find_by(email: params[:email])
		company = Company.find_by(name: params[:company_name])
		company.status_of_company = "accept"
		company.save
		ContactMailer.send_accept_email_to_company(user, company)
		render json: {accept: 'OK'}
	end

	def reject_company
		user = User.find_by(email: params[:email])
		company = Company.find_by(name: params[:company_name])
		company.status_of_company = "reject"
		company.save		
		ContactMailer.send_reject_email_to_company(user, company)
		render json: {reject: 'OK'}
	end 
	
	def edit_campaign
	  @campaign = Campaign.find(params[:id])
	  @company = @campaign.company
	  # if current_user.company != @company
	  #   redirect_to company_path(@company)
	  # end
	  @formc = @company.general_infos.last
	  @members = @company.founders
	  @comments = @company.comments
	end

	def update_campaign
	  @campaign = Campaign.find(params[:company][:campaign_attributes][:id])
	  @company = @campaign.company
	  @campaign.update(tagline: params[:company][:campaign_attributes][:tagline],
	  				  elevator_pitch: params[:company][:campaign_attributes][:elevator_pitch],
	  				  about_campaign: params[:company][:campaign_attributes][:about_campaign],
	  				  category: params[:company][:campaign_attributes][:category],
	  				  employees_numer: params[:company][:campaign_attributes][:employees_numer],
	  				  company_location_city: params[:company][:campaign_attributes][:company_location_city],
	  				  company_location_state: params[:company][:campaign_attributes][:company_location_state])
	  redirect_to :controller => 'companies', :action => 'show', :id => @company.slug
	end

private
	def set_company
	  @company = Company.friendly.find(params[:id])
	end

	def verify
	 	if current_user.confirmed == false
	 		redirect_to url_for(:controller => 'home', :action => 'unverified')
	 	end
	end

	def check_company_accreditation
		if @company.accredited
			return nil
		else
			if current_user
				check_company_ownership
			else
				redirect_to root_path
			end
		end
	end

	def check_company_ownership
		if @company == current_user.company || current_user.authority >= 3
			return
		else
			redirect_to company_not_accretited_path
		end
	end

	def admin_check
		if current_user.authority < User.Authority[:Editor]
			redirect_to url_for(:controller => 'home', :action => 'unauthorized')
		end
	end

	def section_params
		params.require(:section).permit(:id, :company_id, :overview, :target_market, :current_investor_details, :detailed_metrics, :customer_testimonials, :competitive_landscape, :planned_use_of_funds, :pitch_deck, :created_at, :updated_at)
	end

	def company_params
	  params.require(:company).permit(:image, :min_investment, :cover, :id, :end_date, :document, :hidden, :position, :docusign_url,
	   :name, :description, :image, :invested_amount, :website_link, :video_link, :goal_amount, :status, :CEO, :CEO_number,
	   :display, :days_left, :created_at, :updated_at, :suggested_target_price, :fund_america_code,
	   campaign_attributes: [:tagline, :elevator_pitch, :about_campaign, :id, :category, :employees_numer, :company_location_city, :company_location_state],
	   founders_attributes: [:id, :image, :name, :position, :title, :content, :company_id, :created_at, :updated_at, :_destroy],
	   documents_attributes: [:id, :file, :name, :company_id ],
	  financial_detail_attributes: ["id", "offering_terms", "fin_risks", "income", "totat_income", "total_taxable_income",
				       "total_taxes_paid", "total_assets_this_year", "total_assets_last_year", "cash_this_year", "cash_last_year",
				       "acount_receivable_this_year", "acount_receivable_last_year", "short_term_debt_this_year", "short_term_debt_last_year",
				       "long_term_debt_this_year", "long_term_debt_last_year", "sales_this_year", "sales_last_year", "costs_of_goods_this_year",
				       "costs_of_goods_last_year", "taxes_paid_this_year", "taxes_paid_last_year", "net_income_this_year", "net_income_last_year",
				       "company_id","balance_sheet", "income_statements", "statement_of_cash_flow", "statement_changes_of_equity",
				       "business_plan", "party_transaction", "intended_use_of_proceeds", "capital_structure", "material_terms",
				        "financial_conditions", "directors_background", "accountant_review"]  )
	end

	def founder_params
		params.require(:founder).permit(:image, :name, :position, :content, :company_id, :created_at, :updated_at)
	end
end
