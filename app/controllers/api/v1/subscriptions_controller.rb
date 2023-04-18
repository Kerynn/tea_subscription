class Api::V1::SubscriptionsController < ApplicationController 

  def create 
    subscription = Subscription.new(subscription_params)
    subscription.status = 'active'
    if subscription.save 
      render json: { success: "Subscription created successfully" }, status: :created
    else 
      render json: { errors: subscription.errors.full_messages.to_sentence }, status: :bad_request
    end 
  end

  private 

  def subscription_params 
    params.permit(:customer_id, :tea_id, :title, :price, :status, :frequency)
  end
end