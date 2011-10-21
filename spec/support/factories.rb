
FactoryGirl.define do
  sequence :name do |n|
     "name_#{n}"
  end
   
  factory :product do
    Factory.next(:name) {|n| "name#{n}" }
    price 2.00
  end
end

FactoryGirl.define do
  factory :thing do
    Factory.next(:name) {|n| "name#{n}" }
    price 4.00
  end
end

FactoryGirl.define do
  factory :user do
    Factory.next(:name) {|n| "name#{n}" }
  end
end

FactoryGirl.define do

  factory :cart do
    shopper {|a| a.association(:user) }
    state "active"
    after_create {|cart_item| cart_item.send(:initialize_state_machines, :dynamic => :force)}
  end
end

FactoryGirl.define do

  factory :cart_item do
    state "in_cart"
    cart {|a| a.association(:cart) }
    after_create {|cart_item| cart_item.send(:initialize_state_machines, :dynamic => :force)}
  end
end

