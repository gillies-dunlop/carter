
FactoryGirl.define do
  sequence :name do |n|
     "name_#{n}"
  end
   
  factory :product do
    FactoryGirl.generate(:name) {|n| "name#{n}" }
    price 2.00
  end
end

FactoryGirl.define do
  factory :thing do
    FactoryGirl.generate(:name) {|n| "name#{n}" }
    price 4.00
  end
end

FactoryGirl.define do
  factory :user do
    FactoryGirl.generate(:name) {|n| "name#{n}" }
  end
end

FactoryGirl.define do

  factory :cart do
    shopper {|a| a.association(:user) }
    state "active"
    after(:create) {|cart_item| cart_item.send(:initialize_state_machines, :dynamic => :force)}
  end
end

FactoryGirl.define do

  factory :cart_item do
    state "in_cart"
    cart {|a| a.association(:cart) }
    after(:create) {|cart_item| cart_item.send(:initialize_state_machines, :dynamic => :force)}
  end
end

