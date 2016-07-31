require 'rails_helper'

describe UserNotification do
  describe "When module is included" do
    subject { OrderWithIncludedUserNotificationModule.new }

    it 'should have empty notifiers' do
      class_name = subject.class.name
      expect(subject.class.notifiers).to be_empty
    end
  end

  describe ".add_notifier" do
    context "When no block is given" do
      subject { OrderWithEmailNotifier.new }

      it 'should add default email notifier' do
        expect(subject.class.notifiers.size).to eq 1
        expect(subject.class.notifiers[:email]).to eq(UserNotification::Notifiers::EmailNotifier.instance)
      end
    end
  end

  describe "#notifiers" do
    subject { OrderWithEmailNotifier.new }
    it 'should return all available notifiers' do
      expect(subject.notifiers.size).to eq 1
      expect(subject.notifiers[:email]).to eq UserNotification::Notifiers::EmailNotifier.instance
    end
  end

  describe "#notify" do
    subject { OrderWithEmailNotifier.new }
    before { expect(subject.notifiers.size).to eq 1 }

    it 'should call #notify an all availble notifiers' do
      user = double('User')
      expect(UserNotification::Notifiers::EmailNotifier.instance).to receive(:notify).with(:a_template, user).and_call_original
      subject.notify(:a_template, user)
    end

    context "when more than one notifiers exist" do
      pending
    end
  end
end
