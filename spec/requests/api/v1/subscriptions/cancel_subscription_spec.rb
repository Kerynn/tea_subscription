require 'rails_helper'

RSpec.describe 'Cancel Subscription API' do
  it 'can cancel a customer subscription' do
    customer = create(:customer)
    tea_1 = create(:tea)
    tea_2 = create(:tea)
    tea_3 = create(:tea)

    subscription_1 = customer.subscriptions.create!(tea_id: tea_1.id, title: tea_1.title, price: 10.00, status: 'active', frequency: 'monthly')
    subscription_2 = customer.subscriptions.create!(tea_id: tea_2.id, title: tea_2.title, price: 8.99, status: 'active', frequency: 'weekly')
    subscription_3 = customer.subscriptions.create!(tea_id: tea_3.id, title: tea_3.title, price: 5.00, status: 'active', frequency: 'yearly')

    expect(subscription_1.status).to eq('active')

    patch "/api/v1/subscriptions/#{subscription_1.id}"

    success_response = JSON.parse(response.body, symbolize_names: true)
    cancelled = Subscription.find_by(id: subscription_1.id)

    expect(response).to be_successful
    expect(response).to have_http_status(200)
    expect(success_response).to have_key(:success)
    expect(success_response[:success]).to eq("#{subscription_1.title} subscription cancelled successfully")
    expect(cancelled.status).to eq('cancelled')
  end
end