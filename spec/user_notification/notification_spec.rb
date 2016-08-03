require 'rails_helper'
describe UserNotification::Notification do
  context 'initialize' do
    it 'initilizes itself when a hashed is passed' do
      subject = UserNotification::Notification.new(event: :create, model_class: 'User', opts: {a: 1}, _object: 'aaa')
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
      UserNotification::Notification.new(event: :create, model_class: 'Post', opts: { a: 1 }, _object: @post)
    end
    it 'should get the target(s) and call the block' do
      executed = false
      subject.notify(@user) do
        executed = true
      end
      expect(executed).to eq true
      expect(subject.instance_variable_get(:@target)).to eq [@user]
    end

    context 'notify with nested with block' do
      it 'evaluates an email block correctly' do
        executed = false
        subject.notify(@user) do
          with :email do
            template :an_email_template
            executed = true
          end
        end
        expect(executed).to be true
        expect(subject.instance_variable_get(:@template)).to eq :an_email_template
        expect(subject.instance_variable_get(:@notifiers)[:email]).to be_a(UserNotification::Notifiers::EmailNotifier)
        expect(subject.instance_variable_get(:@target)).to eq([@user])
      end

      it 'evaluates correctly an sms block' do
        subject.notify(@user) do
          with :sms do
            payload({ a:1, b: 2 })
          end
        end
        expect(subject.instance_variable_get(:@template)).to eq nil
        expect(subject.instance_variable_get(:@payload)).to eq({a: 1, b: 2})
        expect(subject.instance_variable_get(:@target)).to eq([@user])
        expect(subject.instance_variable_get(:@notifiers)[:sms]).to be_a(UserNotification::Notifiers::SmsNotifier)
      end
    end
    context "multiple notifiers" do
      it '' do
        subject.notify(@user) do
          with :email do
            template :email_template
          end
          with :sms do
            payload a: 1, b: 2
          end
        end
        expect(subject.instance_variable_get(:@notifiers)[:email]).to be_a(UserNotification::Notifiers::EmailNotifier)
        expect(subject.instance_variable_get(:@template)).to eq :email_template
        expect(subject.instance_variable_get(:@payload)).to eq(a: 1, b: 2)
        expect(subject.instance_variable_get(:@notifiers)[:sms]).to be_a(UserNotification::Notifiers::SmsNotifier)
      end
   end
  end

  describe 'dispatch!' do
    subject { UserNotification::Notification.new(event: :create, model_class: 'Post', opts: { a: 1 }, _object: @post) }
    context 'single email notification with no persistance' do
      it 'sends the notification through email notifier' do
        subject.notify @user do
          with :email do
            template :a
          end
        end
        expect(subject.instance_variable_get(:@notifiers)[:sms]).to_not receive(:notify!)
        expect(subject.instance_variable_get(:@notifiers)[:sms]).to_not receive(:persist!)
        expect(subject.instance_variable_get(:@notifiers)[:email]).to receive(:notify!)
        expect(subject.instance_variable_get(:@notifiers)[:email]).to_not receive(:persist!)

        subject.dispatch!
      end
    end
    context 'single email notification' do
      pending
    end
    context 'multiple notifications' do
      pending
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
      _proc = -> () { a_method }

      subject._object = double("SomeObject")
      result = double("Result")

      expect(subject._object).to receive(:a_method).and_return(result)
      expect(subject.send(:should_send?, _proc)).to eq result
    end
  end
end
