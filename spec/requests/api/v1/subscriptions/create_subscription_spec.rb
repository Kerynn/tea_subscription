require 'rails_helper'

RSpec.describe 'Create Subscription API' do 
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
    expect(success_response[:success]).to eq("#{tea.title} Subscription created successfully for #{customer.first_name}")
  end

  it 'will send an error if not able to create a subscription' do
    customer = create(:customer)
    tea = create(:tea)

    expect(customer.subscriptions.empty?).to be true

    headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    body = { tea_id: tea.id, title: tea.title, price: 10.00 }
    post '/api/v1/subscriptions', params: body.to_json, headers: headers

    expect(response).to_not be_successful
    expect(response).to have_http_status(400)
    expect(customer.subscriptions.empty?).to be true

    error_response = JSON.parse(response.body, symbolize_names: true)
    
    expect(error_response).to be_a(Hash)
    expect(error_response).to have_key(:errors)
    expect(error_response[:errors]).to eq("Customer must exist and Frequency can't be blank")
  end

  it 'will send an error if customer already has a subscription to that tea' do
    customer = create(:customer)
    tea = create(:tea)

    subscription_1 = customer.subscriptions.create!(tea_id: tea.id, title: tea.title, price: 10.00, status: 'active', frequency: 'monthly')

    headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    body = { customer_id: customer.id, tea_id: tea.id, title: tea.title, price: 10.00, frequency: 'monthly' }
    post '/api/v1/subscriptions', params: body.to_json, headers: headers

    expect(response).to_not be_successful
    expect(response).to have_http_status(400)
    expect(customer.subscriptions.count).to eq(1)

    error_response = JSON.parse(response.body, symbolize_names: true)
    
    expect(error_response).to be_a(Hash)
    expect(error_response).to have_key(:errors)
    expect(error_response[:errors]).to eq("Customer already has a subscription with this tea")
  end
end