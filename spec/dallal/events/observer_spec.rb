require 'rails_helper'

describe Dallal::Events::Observer do
  subject { Dallal::Events::Observer }
  it { expect(Dallal::Events::Observer.callbacks).to eq [] }
  describe '.inherited' do
    context "when a class inherites from observer" do
      let(:klass) do
        class DummyNotifier < Dallal::Events::Observer
        end
      end

      it 'should validate that model exists and include the model name in NOTIFABLES' do
        expect(Dallal::Events::Observer).to receive(:validate_model_exists!).with('Dummy').and_call_original
        klass
        expect(Dallal::Events::Observer::NOTIFIABLES).to include('Dummy')
      end
    end
  end

  describe '.on' do
    it 'should append args, options and block to callbacks' do
      expect(subject.callbacks.size).to eq 0
      executed = false

      subject.on :create, {a: 2, b: 2} do
        executed = true
      end

      expect(executed).to be false
      expect(subject.callbacks.size).to eq 1
      callback = subject.callbacks[0]
      expect(callback[:on]).to eq([:create])
      expect(callback[:opts]).to eq({a: 2, b: 2})
      expect(callback[:block]).to be_a(Proc)
    end
    context 'multiple definitions' do
      before { subject.instance_variable_set(:@__notification_callbacks, []) }
      it 'append all definitions to callbacks' do
        first_executed = false
        second_executed = false
        subject.on :create, a: 1 do
          first_executed = true
        end

        subject.on :create, b: 2 do
          second_executed = true
        end

        expect(first_executed).to be false
        expect(second_executed).to be false
        expect(subject.callbacks.size).to eq 2
        first_callback = subject.callbacks.first
        second_callback = subject.callbacks.last
        expect(first_callback[:on]).to eq [:create]
        expect(first_callback[:opts]).to eq a: 1
        expect(first_callback[:block]).to be_a Proc

        expect(second_callback[:on]).to eq [:create]
        expect(second_callback[:opts]).to eq b: 2
        expect(second_callback[:block]).to be_a Proc
      end
    end
  end

  describe '.create_notification' do
    subject { UserNotifier }
    before do
      @user = FactoryGirl.create(:user)
    end

    context 'when no callbacks are available' do
      before do
        subject.instance_variable_set(:@__notification_callbacks, [])
        expect(subject.callbacks.size).to eq 0
      end

      it 'does not sipatch any notification' do
        expect_any_instance_of(Dallal::Notification).to_not receive(:dispatch!)
        subject.create_notification(id: 1, event: :create)
      end
    end

    # TODO Refactor these specs
    context 'when a callbacks is defined' do
      context "create event" do
        before { subject.instance_variable_set(:@__notification_callbacks, []) }
        it 'dipatches a notification' do
          @create_block_executed = false

          subject.on :create, a: 1, b: 2 do
            @create_block_executed = true
          end

          notification = double('Dallal::Notification')
          expect(Dallal::Notification).to receive(:new).with(event: :create, model_class: 'User', opts: { a: 1, b: 2 }, _object: @user).and_return(notification)
          expect(notification).to receive(:dispatch!)
          subject.create_notification(id: @user.id, event: :create)

          expect(notification.user).to eq @user
          # TODO Fix this
          #expect(@create_block_executed).to be true
          #expect(@update_block_executed).to be true
        end
      end
      context "update event" do
        before { subject.instance_variable_set(:@__notification_callbacks, []) }
        it 'dispatches an update event' do
          @update_block_executed = false
          subject.on :update, a: 1, b: 2 do
            @update_block_executed = true
          end

          notification = double('Dallal::Notification')
          expect(Dallal::Notification).to receive(:new).with(event: :update, model_class: 'User', opts: { a: 1, b: 2 }, _object: @user).and_return(notification)
          expect(notification).to receive(:dispatch!)
          subject.create_notification(id: @user.id, event: :update)

          expect(notification.user).to eq @user 
        end
      end

      context "mutliple events" do
        before { subject.instance_variable_set(:@__notification_callbacks, []) }
        it 'calls all events' do
          first_executed = false
          second_executed = false

          subject.on :create, a: 1 do
            first_executed = true
          end

          subject.on :create, b: 2 do
            second_executed = true
          end

          notification = double('Dallal::Notification')
          expect(Dallal::Notification).to receive(:new).with(event: :create, model_class: 'User', opts: { a: 1 }, _object: @user).and_return(notification)
          expect(Dallal::Notification).to receive(:new).with(event: :create, model_class: 'User', opts: { b: 2 }, _object: @user).and_return(notification)
          expect(notification).to receive(:dispatch!).exactly(2).times
          subject.create_notification(id: @user.id, event: :create)
        end
      end
    end

    context 'when called with an event that is not defined' do
      before { subject.instance_variable_set(:@__notification_callbacks, []) }
      it 'does not emit a notification' do
        subject.on :create do

        end
        expect_any_instance_of(Dallal::Notification).to_not receive(:dispatch!)
        subject.create_notification(id: @user.id, event: :non_existing)
      end
    end
  end

  describe '.models_class' do
    subject { UserNotifier }
    it { expect(subject.send(:model_class)).to eq 'User' }
  end

  describe '.validate_model_exists!' do
    pending
  end
end
