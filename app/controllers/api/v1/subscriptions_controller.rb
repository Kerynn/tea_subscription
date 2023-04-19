class Api::V1::SubscriptionsController < ApplicationController 

  def create
    subscription = Subscription.new(subscription_params)
    subscription.status = 'active'
    if subscription.save
      render json: { success: "#{subscription.title} Subscription created successfully for #{subscription.customer.first_name}" }, status: :created
    else
      render json: { errors: subscription.errors.full_messages.to_sentence }, status: :bad_request
    end
  end

  def index
    if (customer = Customer.find_by(id: params[:customer_id]))
      render json: SubscriptionSerializer.new(customer.subscriptions)
    else
      render json: { errors: "Customer not found" }, status: :not_found
    end 
  end

  def update
    subscription = Subscription.find_by(id: params[:id])
    if subscription.status == 'active'
      subscription.update(status: 'cancelled')
      render json: { success: "#{subscription.title} subscription cancelled successfully" }, status: :ok
    end
  end

  private 

  def subscription_params 
    params.permit(:customer_id, :tea_id, :title, :price, :status, :frequency)
  end
end