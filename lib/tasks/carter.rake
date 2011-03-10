namespace :carter do
  desc "cleans up expired carts - default is 30 days old but this can be changed by entering the command line argument days=60"
  task :clear_expired_carts => :environment do
    days = (ENV['days'] || 30).to_i.days

    count = Cart.remove_carts(days)
    
    
    puts "#{count} carts deleted."
  end
  

end