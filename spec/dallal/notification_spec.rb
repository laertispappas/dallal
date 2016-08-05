require 'rails_helper'
describe Dallal::Notification do
  context 'initialize' do
    it 'initilizes itself when a hashed is passed' do
      subject = Dallal::Notification.new(event: :create, model_class: 'User', opts: {a: 1}, _object: 'aaa')
      expect(subject.event).to eq :create
      expect(subject.model_class).to eq 'User'
      expect(subject.opts).to eq({a: 1})
      expect(subject._object).to eq 'aaa'
    end
  end
  context "creating a post" do
    before { @user = FactoryGirl.create(:user) }
    it 'foo' do
      FactoryGirl.create(:post, user: @user)
      expect(true).to be true
    end
  end

  before do
    @user = FactoryGirl.create(:user)
    @post = FactoryGirl.create(:post, user: @user)
  end

  describe '#notify' do
    subject do
      Dallal::Notification.new(event: :create, model_class: 'Post', opts: { a: 1 }, _object: @post)
    end

    it 'should get a single target and call the block' do
      executed = false
      subject.notify(@user) do
        executed = true
      end
      expect(executed).to eq true
      expect(subject.targets).to eq [@user]
    end

    it 'should get multiple target and call the block' do
      executed = false
      other = double("OtherUser")
      subject.notify(@user, other) do
        executed = true
      end

      expect(executed).to eq true
      expect(subject.targets).to eq [@user, other]
    end

    context 'notify with nested with block' do
      it 'calls with block' do
        executed = false
        subject.notify(@user) do
          with :email do
            template :an_email_template
            executed = true
          end
        end
        expect(executed).to be true
        notifier = subject.notifiers.first
        expect(notifier).to be_a(Dallal::Notifiers::EmailNotifier)
        expect(notifier.notification.template_name).to eq :an_email_template
        expect(subject.targets).to eq([@user])
      end

      it 'evaluates correctly an sms block' do
        subject.define_singleton_method(:post) {}
        allow(subject).to receive(:post).and_return(@post)
        subject.notify(@user) do
          with :sms do
            message "Message #{post.user.email}"
            recipient post.user.phone_number
          end
        end
        notifier = subject.notifiers.first
        expect(notifier).to be_a(Dallal::Notifiers::SmsNotifier)
        expect(notifier.notification.body).to eq("Message #{@post.user.email}")
        expect(notifier.notification.to).to eq @post.user.phone_number
        expect(subject.targets).to eq([@user])
      end

      it 'calls the block when an if lambda returns true' do
        subject.define_singleton_method('post') do
          @post
        end
        allow(subject).to receive(:post).and_return(@post)

        subject.notify(@user, if: -> (){ post.id.present?} ) do
          with :email do
            template :an_email_template
          end
        end

        expect(subject.notifiers.size).to eq 1
        notifier = subject.notifiers.first
        expect(notifier).to be_a Dallal::Notifiers::EmailNotifier
        expect(notifier.notification.template_name).to eq :an_email_template
        expect(subject.targets).to eq [@user]
      end

      it 'does not call the block when if lambda evaluates to false' do
        subject.define_singleton_method('post') do
          @post
        end
        allow(subject).to receive(:post).and_return(@post)

        subject.notify(@user, if: -> (){ post.id == -100} ) do
          raise "BLock should not be executed"
          with :email do
            raise "BLock should not be executed"
            template :an_email_template
          end
        end
        expect(subject.notifiers).to be_empty
        expect(subject.targets).to be nil
      end
    end

    context "multiple notifiers" do
      it 'fills properties correctly' do
        subject.define_singleton_method(:post) do
          @post
        end
        allow(subject).to receive(:post).and_return(@post)

        subject.notify(@user) do
          with :email do
            template :email_template
          end
          with :sms do
            message "Message #{post.user.email}"
            recipient post.user.phone_number
          end
        end
        email_notifier = subject.notifiers.first
        sms_notifier = subject.notifiers.last

        expect(subject.notifiers.size).to eq 2
        expect(email_notifier).to be_a(Dallal::Notifiers::EmailNotifier)
        expect(email_notifier.notification.template_name).to eq :email_template
        expect(sms_notifier).to be_a(Dallal::Notifiers::SmsNotifier)
        expect(sms_notifier.notification.body).to eq "Message #{@post.user.email}"
        expect(sms_notifier.notification.to).to eq @post.user.phone_number
      end
   end
  end

  describe 'dispatch!' do
    subject { Dallal::Notification.new(event: :create, model_class: 'Post', opts: { a: 1 }, _object: @post) }
    context 'single email notification with no persistance' do
      it 'sends the notification through email notifier' do
        subject.notify @user do
          with :email do
            template :a
          end
        end
        expect(subject.notifiers.size).to eq 1
        expect(subject.notifiers.first).to receive(:notify!)
        expect(subject.notifiers.first).to_not receive(:persist!)

        subject.dispatch!
      end
    end
    context 'single email notification with persistance' do
      pending
    end

    context 'single sms notification' do
      it 'send an sms notification' do
        subject.notify(@user) do
          with :sms do
            message "a message"
          end
        end

        expect(subject.notifiers.size).to eq 1
        expect(subject.notifiers.first).to receive(:notify!)
        expect(subject.notifiers.first).to_not receive(:persist!)

        subject.dispatch!
      end
    end

    context 'single sms notification with persistance' do
      pending
    end

    context 'multiple notifications' do
      pending
    end

    context "multiple users to be notified" do
      it 'sends an notification to each one of them' do
        other = double("OtherUser")
        subject.notify(@user, other) do
          with :sms do
            message 'a message'
          end
        end

        expect(subject.notifiers.size).to eq 2
        expect(subject.notifiers.first).to receive(:notify!)
        expect(subject.notifiers.last).to receive(:notify!)
        subject.dispatch!
      end
    end
  end

  describe "#with" do
    pending
  end

  describe "#get_notifier" do
    before do
      subject.define_singleton_method(:post) {}
      allow(subject).to receive(:post).and_return(@post)
    end
    context "sms notification" do
      context "when recipient is defined" do
        it 'creates a notification and return an sms notifier' do
          blk = proc { message "a message"; recipient post.user }
          notifier = subject.send(:get_notifier, :sms, @user, &blk)
          expect(notifier).to be_a Dallal::Notifiers::SmsNotifier
          notification = notifier.notification
          expect(notification.target).to eq @user
          expect(notification.body).to eq "a message"
          expect(notification.to).to eq @post.user
          expect(notification.from).to eq Dallal.configuration.sms_from
        end
      end
      context "when recipient is not defined" do
        it 'gets the number from target user' do
          blk = proc { message "a message" }
          notifier = subject.send(:get_notifier, :sms, @user, &blk)
          expect(notifier).to be_a Dallal::Notifiers::SmsNotifier
          notification = notifier.notification
          expect(notification.target).to eq @user
          expect(notification.body).to eq "a message"
          expect(notification.to).to eq @post.user.phone_number
          expect(notification.from).to eq Dallal.configuration.sms_from
        end
      end
    end
  end

  describe 'persist?' do
    it 'return true when opts[:persist] is present' do
      presence = double('true')
      subject.opts = {}
      subject.opts[:persist] = presence
      expect(subject.persist?).to be true
    end

    it 'returns false when not present' do
      subject.opts = {}
      expect(subject.persist?).to be false
    end
  end

  describe '#validate!' do
    it 'raises an error when target is nil'
    context "when sending an email notification"
    context "when sending an sms notification"
  end

  describe '#should_send?' do
    subject do
      Dallal::Notification.new(event: :create, model_class: 'Post', opts: { a: 1 }, _object: @post)
    end
    before do
      subject.define_singleton_method('post') do
        @post
      end
      allow(subject).to receive(:post).and_return(@post)
    end


    it 'return true on blank values' do
      [nil, false, ''].each do |val|
        expect(subject.send(:should_send?, val)).to be true
      end
    end

    it 'evaluates a symbol on _object' do
      subject._object = double("Object")
      result = double("Shouldsend")
      expect(subject._object).to receive(:a_method).and_return(result)
      expect(subject.send(:should_send?, :a_method)).to eq result
    end

    it 'evaluates a proc to object instance' do
      _proc = ->(){ post.id.present? }

      result = double("Result")

      expect(subject.post).to receive_message_chain(:id, :present?).and_return(result)
      expect(subject.send(:should_send?, _proc)).to eq result
    end
  end
end
