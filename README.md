# BootstrapAdmin

Dead-simple admin interfaces!<br>
BootstrapAdmin is a small engine designed to ease the construction of administrative interfaces.

## Installation

Add the gem to your Rails app Gemfile:
`gem 'bootstrap_admin'`

And run:
`$ bundle install`

Or just run:
`$ gem install bootstrap_admin`

Then, just run the install generator
`$ rails g bootstrap_admin:install`

By default, bootstrap\_admin will use "admin" as the namespace, but you can change this by adding the wanted namespace:

`$ rails g bootstrap_admin:install --namespace=MyAdmin`

Running the generator will create the following files (assuming the namespace is "admin"):

    config/initializers/bootstrap_admin.rb
    config/bootstrap_admin_menu.yml
    app/assets/javascripts/admin
    app/assets/javascripts/admin.js
    app/assets/stylesheets/admin
    app/assets/stylesheets/admin.css
    app/controllers/admin_controller.rb

## Usage

Bootstrap Admin was designed to be an almost zero-configuration drop-in solution for administration UIs, so getting it up and running is actually pretty simple.

### Defining Routes

Bootstrap Admin comes with a route macro to define the administration section of your app.<br/>
All you need to do is head up to your `config/routes.rb` and add something like:

```ruby
bootstrap_admin do
  # define resources normally here...
  # resources :books
end
```

This will define:

* A basic route to "admin#show"
* A namespace "admin" that will contain all resources defined within the block

### Creating a basic CRUD scaffold

For a basic CRUD interface for an Entity, all you need to do is:

* Generate a Model and set it up (relations, accessible attributes, etc..)
* Generate a Controller that inherits from your AdminController and add the `bootstrap_admin` macro on that controller
* Add the routes to the controller under the bootstrap_admin route<br/>
  `resource :books`

And you're ready to roll!

#### Basic Example - Books

So, assuming you have a Book model:

`$ rails g model Book title:string author:string synopsis:text`
```ruby
class Book < ActiveRecord::Base
  accessible_attributes :title, :author, :synopsis
end
```

All you need on the controller side (assuming you are using "admin" as namespace) is:

`$ rails g controller Admin::Books`
```ruby
class Admin::BooksController < AdminController
  bootstrap_admin
end
```

And a route like:
```ruby
bootstrap_admin do
  resources :books
end
```

And BAM, ready to roll!!

## Configuring Bootstrap Admin - Initializer

This is were you can configure the global options for bootstrap admin.

For now there are only a few options:

* `admin_namespace` - a String defining the name of the namespace to be used
* `paginator_page_size`- an Integer defining the page size for all bootstrap_admin index actions
* `ui_styles` - an Hash that defines CSS classes to be used on certain elements

For now `ui_styles` should contain an hash with more or less the following structure:
```ruby
config.ui_styles = {
  index: %w(table-bordered table-striped)
}
```
The index ui_styles will be used on the index table.
On future releases, this hash will be extended and taken into account for other situations.

### Example of a Bootstrap Admin Initializer

```ruby
BootstrapAdmin.setup do |config|

  # ==> Admin namespace configuration
  # Configure namespace used for the scope of this admin
  # Default value: :admin
  config.admin_namespace = "backoffice"

  # ==> Paginator configuration
  # Configure the number of results shown per page by the paginator.
  # Default value: 10
  config.paginator_page_size = 6

  # ==> UI Styles
  # Configure the css class names that each action wrapper will have
  # Default value: {index: %w(table-bordered table-striped)}
  config.ui_styles[:index] << "my_awesome_style_class"

end
```

## Admin Menu

If you want to customize the bootstrap_admin menu, you can edit the `config/bootstrap_admin_menu.yml` file. There, you can specify the entries you want for the menu, customize the label, an even define dropdown sub-menus.

So, to customize the menu, you must supply a list of menu entries.<br/>
On each entry you can use this set of options:

* `:item`  - one of 3 things:
  * **String**: must be a name of a model (it will be used to build the link url and the label if not supplied)
  * **List**: This will tell bootstrap_admin that the item is in fact a dropdown menu. **In this case `:label` must be supplied.**
  * **Symbol**: currently only `:divider` is supported and produces a division between dropdown elements.
* `:label` - the label that will be presented in the menu. This can be either:
  * **Symbol** - Will be passed to I18n for translation
  * **String** - Will be used directly
  * By default (when not supplied), the label will be the `:item` human name.
* `:namespace` - if your model (`:item`) is under a namespace, then you should declare it on this option
* `:class` - the css class to apply to the item
* `:url` - the url to be used on the item link.
* `:controller` - the controller to be used on the item link.

### Example

```yaml
# Item based on a model
- :item: Document

# Item based on a model, with non-default controller
- :item: NewsArticle
  :controller: admin/news

# Item based on a namespaced model (Blog::Entry)
- :item: Entry
  :namespace: Blog

# Item based on a model with a custom label and css class
- :item: Author
  :label: The guys who write things
  :class: really_bold

# Item based on a model with a custom url
- :item: Search
  :url: "https://google.com"

# Dropdown menu item with several options and a divider
- :label: :user_admin # this will be called as I18n.t(:user_admin)
  :url: "#"
  :item:
  - :item:  Role
  - :item:  :divider
  - :item:  User
    :label: Dudes
```

## Configuring the Controller

By default, bootstrap\_admin will use the fields defined as accessible on the model matching the name of the controller it is working on to build all markup. Also, by default, bootstrap\_admin will respond to `html` and `json` formats.
If you want to override this behavior, the controller macro allows you to pass a block that will be used to configure how bootstrap\_admin will behave.

### Configuring which fields to use

To override the default behavior, you can use the following configurators:

* `index_fields` - the fields to be used on the index action
* `show_fields` - the fields to be used on the show action
* `form_fields` - the fields to be used on all form actions (new, edit, etc..)
* `action_fields` - the fields to be used on all actions. This will only be used when the specific action fields aren't defined.
* `searchable_fields` - the fields to be used while searching

To use these configurators, you pass a block to the bootstrap\_admin macro like so:

```ruby
bootstrap_admin do |config|
  config.index_fields = [:title, :author]
  config.show_fields  = [:title, :author, :synopsis]
  config.form_fields  = [:title, :author, :synopsis]
  config.searchable_fields = [:title]
end
```

### Configuring the action links available

Imagine that for some reason you don't have the need to create new records on a given scaffold. Then, there really shouldn't be a button/link to the new record form...
In order to configure which action links should be shown on a given scaffold, you can use the `available_actions` configurator:

```ruby
bootstrap_admin do |config|
  config.available_actions = [:show, :new]
end
```

With this setting, then your scaffold would only show the link to show on each record and the link to the new record form.

By default the available_actions are:

* `:new` - collection-wise link to the new record form
* `:show` - member-wise link to show the record
* `:edit` - member-wise link to the edit record form
* `:destroy` - member-wise link to destroy the record

No other actions will be taken into account.

### Configuring response formats

bootstrap\_admin also allows you to define to which formats will your controller respond to using the `responder_formats` configurator like so:

```ruby
bootstrap_admin do |config|
  config.responder_formats = [:html, :xml, :json]
end
```

### Configuring which model to use

Sometimes you need a controller to handle a model that has a completely different name from the controller. On those cases, bootstrap\_admin allows you to configure the name of the model to use:

```ruby
class NewsController < AdminController
  bootstrap_admin do |config|
    config.model_name = "NewsArticle"
  end
end
```

## Configuring the Routes

TODO

## Overriding

### Overriding fields with Helper methods

Lets say you have a NewsArticle model that stores news and in that article you have a field named `body` which contains the actual article in the form of markup (built with an WYSIWYG editor like CKEditor). It would be a bummer to display the whole body on the index table!!

bootstrap\_admin allows you to override the field usage by defining a helper like so:
```ruby
def index_body record
  strip_tags(record.body)[0..120] + "..."
end
```

#### Overriding field on `show` or `index` actions

You can override the field usage just for one of the actions or for both at once if applicable.

So, if both actions can use the same display, then your helper must:

* Be named `<field>` - the name of the field
* Accept one argument - the model instance we are displaying

```ruby
def title record
  content_tag(:i, record.title)
end
```

If, on the other hand you need to use different code to display different actions, then your helper must:

* Be named `<action>_<field>`
* Accept one argument - the model instance we are displaying

```ruby
def show_title record
  content_tag(:b, record.title)
end

def index_title record
  content_tag(:i, record.title)
end
```

#### Overriding field on `form` actions (`new`, `edit`, etc..)

This is similar to the overriding done for the `show` and/or `index` actions.

If all your form actions (`new`, `edit`, etc..) can use the same code, then your helper must:

* Be named `form_<field>`
* Accept one argument - the form builder for the model

```ruby
def form_title form
  form.input(:title)
end
```
You can use `form.object` to get the object to which the form is for.

But if you need to use different code on each action, then you can build helpers that must:

* Be named `<action>_form_<field>`
* Accept one argument - the form builder for the model

```ruby
def new_form_title form
  form.input(:title)
end
```

### Overriding the views

TODO

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
