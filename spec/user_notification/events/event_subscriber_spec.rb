require 'rails_helper'

describe UserNotification::Events::EventSubscriber do
  let(:publisher) { UserNotification::Events::EventPublisher }
  let(:payload) { { a: 1, b: 2 } }
  let(:user) { FactoryGirl.build(:user) }
  
  before { allow(user).to receive(:id).and_return(-1) }

  context 'when a create event is broadcasted' do
    it 'creates a new instance and exeutes' do
      base_event = double('UserNotification::Events::EventSubscriber')
      expect(UserNotification::Events::EventSubscriber).to receive(:new).with(class: user.class.name, id: user.id, event: :create).and_return(base_event)
      expect(base_event).to receive(:execute)
      user.save!
    end
  end

  context 'when a create event is broadcasted' do
    it 'creates a new instance and executes' do
      # save the user
      user.save!

      base_event = double('UserNotification::Events::EventSubscriber')
      expect(UserNotification::Events::EventSubscriber).to receive(:new).with(class: user.class.name, id: user.id, event: :update).and_return(base_event)
      expect(base_event).to receive(:execute)

      # update user
      user.save!
    end
  end

  # Instance spec
  let(:payload) do
    {
      class: 'User',
      id: 1,
      event: :create
    }
  end
  
  subject { UserNotification::Events::EventSubscriber.new(payload) }

  describe '#execute' do
    context 'when notifications are supported' do
      before { expect(subject).to receive(:should_create_notifications?).and_return(true) }

      it 'triggers a bg job using ActiveJob' do
        expect(UserNotification::UserNotificationJob).to receive(:perform_later).with(payload[:class], payload[:id], payload[:event].to_s).and_call_original
        subject.execute
      end
    end
    context 'when notifications are not supported' do
      before { expect(subject).to receive(:should_create_notifications?).and_return(false) }
      it 'does not  trigger any job' do
        expect(UserNotification::UserNotificationJob).to_not receive(:perform_later).with(payload[:class], payload[:id], payload[:event].to_s).and_call_original
        subject.execute
      end
    end
  end

  describe '#should_create_notifications?' do
    context 'when notifications are enabled' do
      before { UserNotification.configuration.enabled = true }
      context 'when class is included in notifiables' do
        before { expect(UserNotification::Events::Observer::NOTIFIABLES.include?(payload[:class])).to be_truthy }

        it { expect(subject.send(:should_create_notifications?)).to be_truthy }
      end
      context 'when subject is not a notifiable' do
        before { payload[:class] = 'SomeNonNotifableClass' }
        before { expect(UserNotification::Events::Observer::NOTIFIABLES.include?(payload[:class])).to be_falsey }

        it { expect(subject.send(:should_create_notifications?)).to be_falsey }
      end
    end
    context 'when notifications are disabled' do
      before { UserNotification.configuration.enabled = false }
      context 'when class is included in notifiables' do
        before { expect(UserNotification::Events::Observer::NOTIFIABLES.include?(payload[:class])).to be_truthy }

        it { expect(subject.send(:should_create_notifications?)).to be_falsey }
      end
      context 'when subject ia not a notifiable' do
        before { payload[:class] = 'SomeNonNotifableClass' }
        before { expect(UserNotification::Events::Observer::NOTIFIABLES.include?(payload[:class])).to be_falsey }
        it { expect(subject.send(:should_create_notifications?)).to be_falsey }
      end
    end
  end

end
