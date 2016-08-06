[![Gem
Version](https://badge.fury.io/rb/dallal.svg)](https://badge.fury.io/rb/dallal)
[![Travis Build Status](https://api.travis-ci.org/laertispappas/dallal.svg?branch=master)](https://travis-ci.org/laertispappas/dallal)
[![Code Climate](https://codeclimate.com/github/laertispappas/dallal/badges/gpa.svg)](https://codeclimate.com/github/laertispappas/dallal)
[![Dependency Status](https://gemnasium.com/laertispappas/dallal.svg)](https://gemnasium.com/laertispappas/dallal)

# dallal aka `ντελάλης`
`dallal` is a Rails engine that adds notification capabilities to Rails projects.
The scope of this engine is to provide a simple DSL to create `Notifier` classes that acts
as observers on different events that are published from the application. For the time being
`dallal` supports only email and sms notifications and subscribes to `create` and `update` events of a resource
without allowing any custom events to be emitted. (see TODO list in the end for future features).

## Supported Notification Types
Currently `Dallal` supports email notifications and sms notifications using Twilio REST services.

## Installation

 Add this line to your application's Gemfile:

 ```ruby
 gem 'dallal'
 ```

And then execute:

    $ bundle install


## Usage
Generate `dallal` configuration file:

    $rails g dallal:install

This will create a file under `config/initializers/dallal.rb`. Change `dallal.rb` to your specific config settings.

Include `Dallal` in the resource that you need to publish notifications for.
For example given a polling app:

```ruby
class Poll < ApplicationRecord
    include Dallal
end
```
when included all `create` and `update` events of a poll will be published. In order to "catch" these
events, we need to create the corresponding `PollNotifier` under `app/notifiers/poll_notifier.rb`.
Keep in mind that for the time being location matters and the name must keep the convention of `resource_notifier`.

## Email Notifications

Creating a `PollNotifier` to send an email:

```ruby
--- file app/notifiers/poll_notifier.rb

class PollNotifier < Dallal::Events::Observer
  on :create do
    notify poll.author do
        with :email do
            template :poll_created
        end
    end
  end

  on :update do
    notify poll.author, if: ->() { poll.published? } do
        with :email do
            template :poll_published
        end
    end
  end
end
```

Email templates should live under `app/views/dallal/mailer/{resources}/` were resources is the
plural name of the resource. Every template requires `two` email templates in order to be sent.
* The email subject template
* The email text body itself

By convention subject template should have the template name + the `_subject` postfix. For the
poll example above we need two templates under `app/views/dallal/mailer/polls/`:

* poll_created_subject.text.erb (Email subject)
* poll_created.html.erb (email body)

Inside those templates you have access to an `@notification` instance variable . `@notification`
provides methods to access the resource and the target that the notification is sent to. For the
`PollNotifier` above we will have access to `@notification.poll` and `@notification.target` (poll.author).

Following our poll notifier for `poll_created` template we must have the following erb templates.

```ruby
--- file: app/views/dallal/mailer/polls/poll_created.html.erb`
# This is the email body text
<h3>Hello <%= @notification.target.full_name %></h3>

Your new Poll <%= @notification.poll.title %> is created.
```

```ruby
--- file: app/views/dallal/mailer/polls/poll_created_subject.text.erb`
# This is the email subject text
New Poll: <%= @notification.poll.title %>
```

When a poll is created / updated a job will be enqueue to dispatch the notification. `dallal`
implements active job so any supported queue mechanism should be working.

## SMS Notifications
In order to send an sms notification you need to have a Twilio account. You also need to provide
your `account id`, `auth token` your twilio phone number in `dallal.rb` initializer.

Creating a `UserNotifier` to send sms notifications:

```ruby
--- file app/notifiers/user_notifier.rb

class UserNotifier < Dallal::Events::Observer
  on :create do
    notify user do
        with :sms do
            message "Your code: #{user.generate_some_code}"
            recipient user.profile.phone_number
        end
    end
  end
end
```
If a recipient is not provided `dallal` will try to get the number from `user.phone_number`. If
user does not respond to phone_number an exception will be raised and job will fail. So make sure
that you provide a recipient or that the resource you are sending to implements `#phone_number`
and returns a valid cellphone number.


## Multiple notifications for an event
You can send multiple notifications for a single event by defining `with` block multiple times.
You can also supply notify block as many times as you need for an event
```ruby
--- file app/notifiers/poll_notifier.rb
class PollNotifier < Dallal::Events::Observer
  on :update do
    notify poll.author, if: :published do
        with :email do
            template :published
        end
        with :sms do
            message "Your poll is published."
            recipient poll.author.profile.phone_number
        end
    end

    notify poll.users_interested do
        with :email do
            template :user_interested
        end
    end
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/laertispappas/dallal. This project is intended
to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).

## TODO
* Refactor code to not require all files by default. Currently a user might
interested in email notifications only but for the time being we require sms files also
and most important we use twilio-rb gem.
* Clear out all TODO that exist in the code base
* Write a script to auto generate `dallal.rb` initializer based on available config options.
Currently every time we add a new config attribute we need to update the generator as well.
* Add support for custom events. Drop active record callbacks.
* Remove auto generated events: `create` and `update`
* Refactor `Publisher` and `Subscriber` modules.
* Add support to persist notifications
* Finish generators to create corresponding models and migrations
* Add the option to persist notification on Notifiers
* Add other mean of notification support like Push notifications / Action Cable etc



