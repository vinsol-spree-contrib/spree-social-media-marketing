e = Spree::SocialMediaMarketingEvent.find_or_initialize_by(name: 'Product Creation').tap do |event|
  event.message = "Hey there, we have launched a new product on our store. <name>"
  event.class_to_run = 'Spree::Product'
  event.run_time = 'future'
end
e.save(validate: false)

e = Spree::SocialMediaMarketingEvent.find_or_initialize_by(name: 'Promotion Creation').tap do |event|
  event.message = 'We have a new promotion. <description>'
  event.class_to_run = 'Spree::Promotion'
  event.run_time = 'future'
end
e.save(validate: false)

e = Spree::SocialMediaMarketingEvent.find_or_initialize_by(name: 'Payment Method Creation').tap do |event|
  event.message = 'Hey there, we have activated a new payment method on our store. You can now pay by <name>.'
  event.class_to_run = 'Spree::PaymentMethod'
  event.run_time = 'future'
end
e.save(validate: false)

e = Spree::SocialMediaMarketingEvent.find_or_initialize_by(name: 'User Milestone').tap do |event|
  event.message = 'Hurray. We have reached <customer_count> users.'
  event.class_to_run = 'Spree.user_class'
  event.run_time = 'inline'
  event.threshold = 100
end
e.save(validate: false)

e = Spree::SocialMediaMarketingEvent.find_or_initialize_by(name: 'Order Milestone').tap do |event|
  event.message = 'Hurray. We have reached <completed_order_count> orders.'
  event.class_to_run = 'Spree::Order'
  event.run_time = 'inline'
  event.threshold = 100
end
e.save(validate: false)

e = Spree::SocialMediaMarketingEvent.find_or_initialize_by(name: 'Low Stock Products').tap do |event|
  event.message = 'Hurry up. <product_name> is selling fast. Only <product_quantity> left.'
  event.class_to_run = 'Spree::StockMovement'
  event.run_time = 'inline'
  event.threshold = 10
end
e.save(validate: false)
