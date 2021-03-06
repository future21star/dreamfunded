class CreateAccountForPlaidService

  # creates a new plaid_rails_account for each account the user has selected
  def self.create(account_params)
    account_params["account_ids"].each  do |id|
      # set Plaid::User
      user = Plaid.set_user(account_params["access_token"],['connect'])
      #find the account by account_id 
      account = user.accounts.find{|a| a.id==id}
      PlaidAccount.create!(
        access_token: account_params["access_token"], 
        token: account_params["token"],
        plaid_type: account_params["type"],
        name: account.name,
        bank_name: Plaid.institution.find{|i| i.type==account_params["type"]}.name,
        number: account.meta["number"],
        owner_id: account_params["owner_id"],
        owner_type: account_params["owner_type"],
        available_balance: account.available_balance,
        current_balance: account.current_balance,
        transactions_start_date: account_params["transactions_start_date"],
        plaid_id: id
      ) unless PlaidAccount.exists?(plaid_id: id)
    end
    
    PlaidAccount.where(owner_id: account_params["owner_id"], 
      owner_type: account_params["owner_type"])
  end
end
