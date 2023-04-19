class SubscriptionSerializer 
  include JSONAPI::Serializer

  attributes :tea_id, :title, :price, :status, :frequency
end