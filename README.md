# BootstrapAdmin

Dead-simple admin interfaces!<br>
BootstrapAdmin is a small engine designed to ease the construction of administrative interfaces.

## Installation

Add the gem to your Rails app Gemfile:

    gem 'bootstrap_admin'

And run:

    $ bundle install

Or just run:

    $ gem install bootstrap_admin

Then, just run the install generator

    $ rails g bootstrap_admin:install

By default, bootstrap\_admin will use "admin" as the namespace, but you can change this by adding the wanted namespace:

    $ rails g bootstrap_admin:install --namespace=MyAdmin

This will create the following files (assuming the namespace is "admin"):

    config/initializers/bootstrap_admin.rb
    config/bootstrap_admin_menu.yml
    app/assets/javascripts/admin
    app/assets/javascripts/admin.js
    app/assets/stylesheets/admin
    app/assets/stylesheets/admin.css

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
