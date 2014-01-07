# carter

A simple shopping cart for ruby.

  [Carter]("http://en.wikipedia.org/wiki/Carter_\(name\)/") - "transports goods by cart"
  
* Anything can be added to the cart using 
  `acts_as_cartable`
* Any page can load a cart from session.
* Can be included without a need for a complete e-commerce solution.

## Install

Add to the Gemfile

```ruby
gem 'carter'
```

Copy migration file

```console
rails generate carter:migration
```

Copy carter files to your project to extend (optional)
```console
rails generate carter:install
```

## Support

This gem supports Rails 4.0, if you need Rails 2.3 and Rails 3+ support, please install carter 0.7. 

## Contributing to carter
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Louis Gillies. See LICENSE.txt for
further details.

