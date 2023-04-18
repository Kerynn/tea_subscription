require 'rails_helper'

RSpec.describe 'Subscription API' do 
  it 'can create a customer subscription' do 
    customer = create(:customer)
    tea = create(:tea)
  
    expect(customer.subscriptions.empty?).to be true
  
    headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    body = { customer_id: customer.id, tea_id: tea.id, title: tea.title, price: 10.00, frequency: 'monthly' }
    post '/api/v1/subscriptions', params: body.to_json, headers: headers

    expect(response).to be_successful
    expect(response).to have_http_status(201)
    expect(customer.subscriptions.empty?).to be false

    success_response = JSON.parse(response.body, symbolize_names: true)

    expect(success_response).to be_a(Hash)
    expect(success_response).to have_key(:success)
    expect(success_response[:success]).to eq("Subscription created successfully")
  end
end