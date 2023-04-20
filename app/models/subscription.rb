class Subscription < ApplicationRecord
  belongs_to :tea
  belongs_to :customer

  validates_presence_of :title, :price, :status, :frequency
  validates_uniqueness_of :customer_id, { scope: :tea_id, message: "already has a subscription with this tea" }
end