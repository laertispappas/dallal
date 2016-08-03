module UserNotification
  class Mailer < ActionMailer::Base
    layout UserNotification.configuration.email_layout

    def notify(notification)
      @notification = notification
      mail(mail_attrs)
    end

    private
    def mail_attrs
      {
        from: address_format(config.system_email, @notification.from_name),
        reply_to: address_format(@notification.from_email, @notification.from_name),
        to: @notification.user.email,
        cc: @notification.cc,
        subject: subject,
        template_name: @notification.template
      }
    end

    def subject
      render_to_string(template: "user_notification/mailer/#{@notification.template}_subject") 
    end

    def address_format email, name
      address = Mail::Address.new email
      address.display_name = name
      address.format
    end

    def confif
      UserNotification.configuration
    end
  end
end
