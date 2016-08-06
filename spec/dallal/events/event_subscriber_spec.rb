require 'rails_helper'

describe Dallal::Events::EventSubscriber do
  let(:publisher) { Dallal::Events::EventPublisher }
  let(:payload) { { a: 1, b: 2 } }
  let(:user) { FactoryGirl.build(:user) }
  
  before { allow(user).to receive(:id).and_return(12) }

  context 'when a create event is broadcasted' do
    it 'creates a new instance and exeutes' do
      base_event = double('Dallal::Events::EventSubscriber')
      expect(Dallal::Events::EventSubscriber).to receive(:new).with(class: user.class.name, id: user.id, event: :create).and_return(base_event)
      expect(base_event).to receive(:execute)
      user.save!
    end
  end

  context 'when a create event is broadcasted' do
    # Failes randomly
    it 'creates a new instance and executes' do
      # save the user
      user.save!

      base_event = double('Dallal::Events::EventSubscriber')
      expect(Dallal::Events::EventSubscriber).to receive(:new).with(class: user.class.name, id: user.id, event: :update).and_return(base_event)
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
  
  subject { Dallal::Events::EventSubscriber.new(payload) }

  describe '#execute' do
    context 'when notifications are supported' do
      before { expect(subject).to receive(:should_create_notifications?).and_return(true) }

      it 'triggers a bg job using ActiveJob' do
        expect(Dallal::DallalJob).to receive(:perform_later).with(payload[:class], payload[:id], payload[:event].to_s).and_call_original
        subject.execute
      end
    end
    context 'when notifications are not supported' do
      before { expect(subject).to receive(:should_create_notifications?).and_return(false) }
      it 'does not  trigger any job' do
        expect(Dallal::DallalJob).to_not receive(:perform_later).with(payload[:class], payload[:id], payload[:event].to_s).and_call_original
        subject.execute
      end
    end
  end

  describe '#should_create_notifications?' do
    context 'when notifications are enabled' do
      before { Dallal.configuration.enabled = true }
      context 'when class is included in notifiables' do
        before { expect(Dallal::Events::Observer::NOTIFIABLES.include?(payload[:class])).to be_truthy }

        it { expect(subject.send(:should_create_notifications?)).to be_truthy }
      end
      context 'when subject is not a notifiable' do
        before { payload[:class] = 'SomeNonNotifableClass' }
        before { expect(Dallal::Events::Observer::NOTIFIABLES.include?(payload[:class])).to be_falsey }

        it { expect(subject.send(:should_create_notifications?)).to be_falsey }
      end
    end
    context 'when notifications are disabled' do
      before { Dallal.configuration.enabled = false }
      context 'when class is included in notifiables' do
        before { expect(Dallal::Events::Observer::NOTIFIABLES.include?(payload[:class])).to be_truthy }

        it { expect(subject.send(:should_create_notifications?)).to be_falsey }
      end
      context 'when subject ia not a notifiable' do
        before { payload[:class] = 'SomeNonNotifableClass' }
        before { expect(Dallal::Events::Observer::NOTIFIABLES.include?(payload[:class])).to be_falsey }
        it { expect(subject.send(:should_create_notifications?)).to be_falsey }
      end
    end
  end

end
