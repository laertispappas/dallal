require 'rails_helper'

module UserNotification
  RSpec.describe UserNotificationJob, type: :job do
    let(:args) { { class: 'User', id: '1', event: 'create'} }

    describe '#perform' do
      it 'constantizes and calls #create_notification on notifier with correct args' do
        expect(UserNotifier).to receive(:create_notification).with(id: '1', event: :create)
        subject.perform(args[:class], args[:id], args[:event])
      end
    end
  end
end
