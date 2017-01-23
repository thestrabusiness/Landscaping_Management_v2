require 'rails_helper'

feature 'User view client index page' do
  context 'when clients exist' do
    scenario 'user views the index page' do
      @clients = create_list(:client, 3, :with_billing_address)

      visit clients_path

      expect_page_to_have_clients_info
      expect(page).to have_link('Add New Client')
    end
  end

  def expect_page_to_have_clients_info
    @clients.each do |client|
      expect_page_to_have_client_info(client)
    end
  end

  def expect_page_to_have_client_info(client)
    expect(page).to have_content client.first_name
    expect(page).to have_content client.last_name
    expect(page).to have_content client.full_billing_address
    expect(page).to have_content client.balance
  end
end