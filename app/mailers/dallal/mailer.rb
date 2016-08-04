module Dallal
  class Mailer < ActionMailer::Base
    layout Dallal.configuration.email_layout

    # TODO add mailer specs
    def notify(notification)
      @notification = notification
      mail(mail_attrs)
    end

    private
    def mail_attrs
      {
        from: address_format(@notification.from_email, @notification.from_name),
        reply_to: address_format(@notification.from_email, @notification.from_name),
        to: @notification.user.email,
        cc: nil,
        subject: subject,
        template_name: "#{object_plural_name}/#{@notification.template_name}"
      }
    end

    def subject
      render_to_string(template: "dallal/mailer/#{object_plural_name}/#{@notification.template_name}_subject")
    end

    def address_format email, name
      address = Mail::Address.new email
      address.display_name = name
      address.format
    end
    def object_plural_name
      @notification._object.class.name.underscore.pluralize
    end
  end
end
