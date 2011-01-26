Factory.sequence :name do |n|
   "name_#{n}"
 end
 
Factory.define :product do |f|
  f.sequence(:name) {|n| "name#{n}" }
  f.price 2.00
end

Factory.define :thing do |f|
  f.sequence(:name) {|n| "name#{n}" }
  f.price 4.00
end

Factory.define :user do |f|
  f.sequence(:name) {|n| "name#{n}" }
end

Factory.define :cart do |f|
  f.shopper {|a| a.association(:user) }
end

Factory.define :cart_item do |f|
  f.cart {|a| a.association(:cart) }
end
