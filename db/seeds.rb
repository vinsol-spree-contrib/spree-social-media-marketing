e = Spree::SocialMediaMarketingEvent.find_or_initialize_by(name: 'product_creation').tap do |event|
  event.message = "Hey there, we have launched a new product on our store. <name>"
  event.class_to_use = 'Spree::Product'
  event.run_time = 'future'
end
e.save(validate: false)

e = Spree::SocialMediaMarketingEvent.find_or_initialize_by(name: 'promotion_creation').tap do |event|
  event.message = 'We have a new promotion. <description>'
  event.class_to_use = 'Spree::Promotion'
  event.run_time = 'future'
end
e.save(validate: false)

e = Spree::SocialMediaMarketingEvent.find_or_initialize_by(name: 'payment_method_creation').tap do |event|
  event.message = 'Hey there, we have activated a new payment method on our store. You can now pay by <name>.'
  event.class_to_use = 'Spree::PaymentMethod'
  event.run_time = 'future'
end
e.save(validate: false)

e = Spree::SocialMediaMarketingEvent.find_or_initialize_by(name: 'user_milestone').tap do |event|
  event.message = 'Hurray. We have reached <customer_count> users.'
  event.class_to_use = 'Spree.user_class'
  event.run_time = 'inline'
end
e.save(validate: false)

e = Spree::SocialMediaMarketingEvent.find_or_initialize_by(name: 'order_milestone').tap do |event|
  event.message = 'Hurray. We have reached <completed_order_count> orders.'
  event.class_to_use = 'Spree::Order'
  event.run_time = 'inline'
end
e.save(validate: false)

e = Spree::SocialMediaMarketingEvent.find_or_initialize_by(name: 'low_stock_products').tap do |event|
  event.message = 'Hurry up. <product_name> is selling fast. Only <product_quantity> left.'
  event.class_to_use = 'Spree::StockMovement'
  event.run_time = 'inline'
end
e.save(validate: false)
