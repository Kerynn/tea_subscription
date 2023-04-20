require 'rails_helper'

RSpec.describe 'Get Subscriptions API' do
  it 'can get all the subscriptions for a customer' do 
    customer = create(:customer)
    tea_1 = create(:tea)
    tea_2 = create(:tea)
    tea_3 = create(:tea)
    tea_4 = create(:tea)

    subscription_1 = customer.subscriptions.create!(tea_id: tea_1.id, title: tea_1.title, price: 10.00, status: 'active', frequency: 'monthly')
    subscription_2 = customer.subscriptions.create!(tea_id: tea_2.id, title: tea_2.title, price: 8.99, status: 'cancelled', frequency: 'weekly')
    subscription_3 = customer.subscriptions.create!(tea_id: tea_3.id, title: tea_3.title, price: 5.00, status: 'active', frequency: 'yearly')

    expect(customer.subscriptions.count).to eq(3)

    get "/api/v1/subscriptions?customer_id=#{customer.id}"

    expect(response).to be_successful

    subscriptions = JSON.parse(response.body, symbolize_names: true)

    expect(subscriptions).to be_a(Hash)
    expect(subscriptions).to have_key(:data)
    expect(subscriptions[:data]).to be_an(Array)
    expect(subscriptions[:data].count).to eq(3)
    
    subscriptions[:data].each do |subscription|
      expect(subscription).to have_key(:id)
      expect(subscription).to have_key(:type)
      expect(subscription[:type]).to eq('subscription')
      expect(subscription).to have_key(:attributes)
      expect(subscription[:attributes]).to be_a(Hash)

      expect(subscription[:attributes]).to have_key(:tea_id)
      expect(subscription[:attributes][:tea_id]).to be_an(Integer)

      expect(subscription[:attributes]).to have_key(:title)
      expect(subscription[:attributes][:title]).to be_a(String)

      expect(subscription[:attributes]).to have_key(:price)
      expect(subscription[:attributes][:price]).to be_a(Float)

      expect(subscription[:attributes]).to have_key(:status)
      expect(subscription[:attributes][:status]).to be_a(String)

      expect(subscription[:attributes]).to have_key(:frequency)
      expect(subscription[:attributes][:frequency]).to be_a(String)
    end
  end

  it 'will return an error if no customer is found' do
    get "/api/v1/subscriptions?customer_id=9999999999"

    expect(response).to_not be_successful
    expect(response).to have_http_status(404)

    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(error_response).to be_a(Hash)
    expect(error_response).to have_key(:errors)
    expect(error_response[:errors]).to eq("Customer not found")
  end

  it 'will return an empty array is customer does not have any subscriptions' do 
    customer = create(:customer)
    expect(customer.subscriptions.count).to eq(0)

    get "/api/v1/subscriptions?customer_id=#{customer.id}"

    expect(response).to be_successful

    subscriptions = JSON.parse(response.body, symbolize_names: true)

    expect(subscriptions).to be_a(Hash)
    expect(subscriptions).to have_key(:data)
    expect(subscriptions[:data].count).to eq(0)
  end
end