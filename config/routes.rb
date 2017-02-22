Rails.application.routes.draw do

  root 'home#index'

  devise_for :users, controllers: {:registrations => 'registrations'}

  ActiveAdmin.routes(self)

  get '/team', to: "members#index", as: :members
  post 'members', to: 'members#create'
  get 'members/new', to: "members#new", as: :new_member
  get 'members/:id/edit', to: 'members#edit', as: :edit_member
  get '/team/:id', to: "members#show", as: :member
  patch 'team/:id', to: 'members#update'
  put 'team/:id', to: 'members#update'
  delete 'team/:id', to: 'members#destroy'

  match "/companies/next-minute-inc" => redirect("/"), via: 'get'
  mount Ckeditor::Engine => '/ckeditor'
  get '/posts/new/:page', to: "posts#new"
  get '/posts/:id/edit/:page', to: "posts#edit"
  resources :posts

  resources :companies do
    collection do
      get 'accept_company', to: 'companies#accept_company'
      get 'reject_company', to: 'companies#reject_company'
    end
  end
  resources :news
  resources :documents
  resources :guests
  resources :comments
  resources :invites
  resources :bids
  resources :events
  resources :groups
  resources :press_posts, except: [:index]
  get '/press', to: "press_posts#index"

  #I N V E S T O R   S U B M I T
  get '/personal_info/:name', to: 'invest#personal', as: 'personal'
  post '/personal_submit/:name', to: 'invest#personal_submit'

  get '/investor_details/:name', to: 'invest#investor_details', as: 'investor_details'
  post '/investor_details_submit/:name', to: 'invest#investor_details_submit'

  get '/educational_disclaimer/:name', to: 'invest#educational_disclaimer', as: 'educational_disclaimer'
  post '/educational_disclaimer_submit/:name', to: 'invest#educational_disclaimer_submit'

  get '/subscription_agreement/:name', to: 'invest#subscription', as: 'subscription'
  post '/subscription_agreement_submit/:name', to: 'invest#subscription_agreement_submit'

  get '/pre_purchase/:name', to: 'invest#pre_purchase', as: 'pre_purchase'
  post '/pre_purchase_submit/:name', to: 'invest#pre_purchase_submit'
  get '/investment_payment', to: 'invest#payment'

  post '/investment_made/:id', to: 'invest#investment_made'

  # Company Compaign Submit
  get '/funding_goal', to: 'campaigns#funding_goal', as: 'funding_goal'
  post '/funding_goal_submit', to: 'campaigns#funding_goal_submit'
  get '/funding_campaing_goal/:id', to: 'campaigns#funding_goal_exist', as: 'funding_goal_exist'
  patch '/funding_goal_update', to: 'campaigns#funding_goal_update'
  get '/campaign_basics/:id', to: 'campaigns#basics', as: 'campaign_basics'
  post '/basics_submit', to: 'campaigns#basics_submit'
  get '/company_description/:id', to: 'campaigns#description', as: 'description'
  patch '/company_description_submit', to: 'campaigns#company_description_submit'
  get '/legal_info/:id', to: 'campaigns#legal_info', as: 'legal_info'
  post '/legal_info_submit', to: 'campaigns#legal_info_submit'
  get '/financial_info/:id', to: 'campaigns#financial_info', as: 'financial_info'
  post '/financial_info_submit', to: 'campaigns#financial_info_submit'
  get '/campaign_review/:id', to: 'campaigns#campaign_review', as: 'campaign_review'

  get '/edit_campaign/:id', to: 'companies#edit_campaign', as: 'edit_campaign'
  patch '/update_campaign', to: 'companies#update_campaign'

  get '/manage_team', to: 'campaigns#team', as: "manage_team"

  get 'formc/print/:id', to: "formc#print", as: 'formc'
  get 'formc/:id', to: "formc#show", as: 'formc_show'
  get 'formc/edit/:id', to: "formc#edit", as: :edit_formc

  get "company_not_accretited", to: "companies#company_not_accretited", as: "company_not_accretited"


  match "/diversity-tech-angels-earn-wings/" => redirect("https://dreamfundedsf.wpengine.com/diversity-tech-angels-earn-wings/"), via: 'get'

  get 'payment/index'
  get 'news/manage'
  get 'welcome/index'

  get '/authenticate', to: 'import#authenticate'
  get '/authorise', to: 'import#authorise'
  get '/import', to: 'import#import'

  post '/authenticate', to: 'import#authenticate'
  post '/authorise', to: 'import#authorise'
  post '/import', to: 'import#import'

  get 'auth/google_oauth2/callback', to:'omniauth_callbacks#google_oauth2'
  post 'auth/google_oauth2/callback', to:'omniauth_callbacks#google_oauth2'

  get 'auth/linkedin/callback', to:'omniauth_callbacks#google_oauth2'
  post 'auth/linkedin/callback', to:'omniauth_callbacks#google_oauth2'

  get 'auth/facebook/callback', to:'omniauth_callbacks#google_oauth2'
  post 'auth/facebook/callback', to:'omniauth_callbacks#google_oauth2'

  get 'auth/yahoo/callback', to:'omniauth_callbacks#google_oauth2'
  post 'auth/yahoo/callback', to:'omniauth_callbacks#google_oauth2'

  # B I D D I N G   S Y S T E M
  get 'bid/:id', to: "bids#bid"
  get 'sellers_bids', to: "bids#sellers_bids"
  get 'accept_bid/:id', to: "bids#accept"
  get 'decline_bid/:id', to: "bids#decline"
  get 'counter_offer/:id', to: "bids#counter_offer"
  post 'send_counter_offer', to: "bids#send_counter_offer"
  get 'confirm', to: "bids#confirm", as: :confirm
  post 'update_bid_offer', to: "bids#update_bid_offer", as: :update_bid_offer
  get "docusign", to: "sellers#docusign", as: :docusign
  get "check-status", to: "sellers#check_status", as: :check_status
  #post '/account/1613988/envelopes', to: "sellers#send", as: :send_docusign

  get '/manny-fernandez', to: 'members#manny', as: :manny
  get '/rexford-r-hibbs', to: 'members#rexford', as: :rexford

  get 'users/portfolio', to: "users#portfolio", as: :portfolio
  get 'users/portfolio_admin/:id', to: "admin#portfolio_admin", as: :portfolio_admin
  post 'users/portfolio_admin/:id', to: "admin#remove_investment", as: :remove_investment

  get '/mentors', to: "users#advisors", as: :advisors
  get '/diversitynetwork', to: "home#diversitynetwork", as: :diversitynetwork

  get 'new/full/:id', to: "news#full", as: :full_article
  post 'home_controller/create', to: "home#create"
  post 'companies_controller/add_team_member', to: "companies#add_team_member"

  get '/change_password', to: "users#change_password", as: :change_password
  post '/post_change_password', to: "users#post_change_password", as: :post_change_password

  get '/new_password', to: "users#new_password", as: :new_password
  post '/reset_password', to: "users#reset_password", as: :reset_password

  post '/users/verify', to: 'users#verify', as: 'user_verify'

  get '/users/certify', to: "users#certify", as: 'certify'

  get 'users/admin', to: "users#admin"
  get 'users/admin-companies', to: "admin#companies"
  get '/my_campaigns', to: "users#campaign"

  post '/marketplace_signup', to: 'guests#marketplace'

  get 'homes/faq', to: "home#faq", as: :faq
  get '/legal', to: "home#legal", as: :legal
  get '/contact', to: 'home#contact_us'
  post '/contact_us', to: 'home#contact_us_send_email'

  post '/join_waitlist', to: 'companies#join_waitlist_send_email'
  get '/join_waitlist_thank_you', to: 'companies#join_waitlist_thank_you'


  get '/liquidate', to: 'home#liquidate'
  get '/liquidity', to: 'home#liquidate'
  post '/liquidate_form', to: 'home#liquidate_form'

  get '/shares', to: 'sellers#shares'
  get '/edit-shares/:id', to: 'sellers#edit'
  post '/update-shares', to: 'sellers#update'

  get '/home/edit_member/:id', to: "home#team_member_edit"
  put '/home/edit_member', to: 'home#team_member_update'
  # patch '/home/edit_member', to: 'home#team_member_update', as: 'update_member'

  get '/sellers', to: "home#sellers", as: :sellers
  get '/edit_seller/:id', to: "home#edit_seller", as: 'edit_seller'
  patch '/liquidate_shares', to: "home#edit_liq_seller", as: :edit_shareholder


  get '/new_seller', to: "home#new_seller"
  post '/new_seller', to: "home#create_new_seller", as: :create_shareholder


  # I N V I T E S
  get '/invite', to: "invites#invite", as: :invite_users
  post '/google_contacts', to: "invites#google_contacts"
  post "/upload_csv", to: "invites#upload_csv"
  post "/invites_from_manny", to: "invites#invites_from_manny"
  post "/send_start_up_emails", to: "invites#send_start_up_emails"

  get "/invite_cofounder", to: "invites#invite_cofounder"
  post "/invite_cofounder", to: "invites#post_invite_cofounder"

  get 'download_template', to: "invites#download"
  get '/view_uploaded_csv', to: "invites#view_uploaded_csv", as: :view_uploaded_csv
  #post '/send_csv_invites', to: "invites#send_csv_invites"

  get '/accept-invite', to: "invites#accept"
  get '/accept-invite-facebook/:id', to: "invites#accept_from_facebook"
  get '/create-invite/:id', to: 'invites#create_from_social'

  post '/send_from_team_member', to: 'invites#send_from_team_member'

  post '/send_from_advisor', to: 'invites#send_from_advisor'
  post '/send_advisors_csv_invites', to: 'invites#send_advisors_csv_invites'

  post '/invite_from_startup', to: "invites#invite_from_startup", as: :invite_from_startup
  post '/invite_to_group', to: "invites#invite_to_group", as: :invite_to_group

  get '/unsubscribe/:email', to: 'guests#unsubscribe'

  #resources :teams

  get '/team/:id', to: "members#show", as: :team

  get '/payment', to: "payments#index", as: :payment
  post '/submit_payment', to: "payments#payment"
  get '/congratulation/:id', to: "payments#congrats", as: :congratulation

  get '/blog', to: "posts#blog", as: :blog
  get '/blog_post/:id', to: "posts#blog_post", as: :blog_post

  #URLs from old site
  get '/how-it-works', to: 'home#why'
  get '/why-invest-with-dream-funded', to: 'home#why'
  get '/faq', to: 'home#faq'
  get '/how_it_works', to: 'home#howItWorks'
  get '/about', to: 'home#about'
  get '/privacy_policy', to: 'home#privacy_policy'

  # E D U C A T I O N
  get '/education', to: 'education#education', as: 'education'
  get '/education/investors-basics', to: 'education#investors_basics'
  get '/education/startup-basics', to: 'education#startup_basics'
  get '/education/investing-tips', to: 'education#tips', as: 'education_tips'
  get '/education/investors-important-terms', to: 'education#investors_terms'
  get '/education/startups-important-terms', to: 'education#startups_terms'
  get '/education/taxes-gains', to: 'education#taxes', as: 'education_taxes'
  get '/education/investor-qa', to: 'education#investorqa', as: 'investorqa'
  get '/education/employee-qa', to: 'education#employeeqa', as: 'employeeqa'
  get '/education/market_trends', to: 'education#market_trends', as: 'market_trends'
  get '/education/jobs_act', to: 'education#jobs_act', as: 'jobs_act'
  get '/education/fund_raising_guide', to: 'education#fund_raising_guide', as: 'fund_raising_guide'

  # G R O U P S
  get '/join_group/:id', to: 'groups#join_group', as: 'join_group'


  get '/resources', to: 'home#resources'
  get '/marketplace', to: 'home#marketplace'
  get '/book', to: 'home#book'

  get '/portfolio', to: 'users#portfolio'
  match '/dreamfunded-exchange' => redirect("http://svexchange.com/dreamfunded-exchange"), via: 'get'
  get '/our-team', to: 'members#index'

  match "/our-team/manny-fernandez" => redirect("team/manny-fernandez"), via: 'get'
  match "/our-team/rexford-r-hibbs" => redirect("team/rexford-r-hibbs"), via: 'get'
  match "/our-team/manny-fernandez" => redirect("team/manny-fernandez"), via: 'get'
  match "/our-team/helder-suzuki" => redirect("team/helder-suzuki"), via: 'get'
  match "/our-team/jacob-white" => redirect("team/jacob-white"), via: 'get'
  match "/our-team/bill-payne" => redirect("team/bill-payne"), via: 'get'
  match "/dreamfunded-mentioned-forbes-get-introduced-investors/" => redirect("news/dreamfunded-mentioned-in-forbes"), via: 'get'
  match "/startups-vie-funding-shark-tank-event/" => redirect("news/startups-vie-for-funding-at-shark-tank-event"), via: 'get'
  # get '/signup', to: 'users#new'
  get '/login', to: 'users#login'
  get "/information-selling-equity", to: 'home#exchange'
  match "/regulation-mini-ipos-way-rule-change-allows-regular-joes-invest-startups/" => redirect("news/regulation-a-mini-ipos-on-the-way-as-rule-change-allows-regular-joes-to-invest-in-startups"), via: 'get'
  get '/funding', to: 'home#index'


  resources :users, only: [:update, :edit, :create, :new]
  get ':controller(/:action(/:id))'
  post ':controller(/:action(/:id))'


  # match "/:id" => redirect("/"), via: 'get'

  #Plaid 
  mount PlaidRails::Engine => '/plaid', as: :plaid_rails

  #Payment Gateways Integation
  resources :invest_with_gateways
  get "/invest_for_company/:user_id/:id", to: "invest_with_gateways#invest_for_company", as: "invest_for_company"
  get "/invest_with_paypal/:id", to: "invest_with_gateways#invest_with_paypal", as: "invest_with_paypal" 
  get "/invest_with_plaid/:id", to: "invest_with_gateways#invest_with_plaid", as: "invest_with_plaid"
  post "/return_from_paypal/:user_id/:id", to: "invest_with_gateways#return_from_paypal", as: "return_from_paypal"
  post "/hook" => "invest_with_gateways#hook"
  post "/authenticate_bank_account_for_plaid", to: "invest_with_gateways#authenticate_bank_account_for_plaid", as: "authenticate_bank_account_for_plaid"
  post "/update_bank_account_for_plaid", to: "invest_with_gateways#update_bank_account_for_plaid", as: "update_bank_account_for_plaid"
  post "/update_selected_account", to: "invest_with_gateways#update_selected_account_for_current_user", as: "update_selected_account_for_current_user"
  get "/get_bank_info_for_current_user", to: "invest_with_gateways#get_bank_info_for_current_user", as: "get_bank_info_for_current_user"
  get "/get_selected_accont_for_current_user", to: "invest_with_gateways#get_selected_accont_for_current_user", as: "get_selected_accont_for_current_user"
  #FundAmerica
  post "/create_offering", to: "fundamerica_business#create_offering", as: "create_offering"
  get "/list_offerings", to: "fundamerica_business#list_offerings", as: "list_offerings"
  post "/create_investment", to: "fundamerica_business#create_investment", as: "create_investment"
  get "/get_subscription_agreement/:offering_id/:issuer_id/:amount", to: "fundamerica_business#get_subscription_agreement", as: "get_subscription_agreement"
  #HelloSign
  resources :signatures, only: [:new] do
    collection do
      post 'callbacks'
      post 'create_signature'
    end
  end
end
