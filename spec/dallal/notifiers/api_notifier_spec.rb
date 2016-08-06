require 'rails_helper'

describe Dallal::Notifiers::ApiNotifier do
  let(:target) { double('UserTarget') }
  let(:notification) { double('ApiNotification', target: target, client: nil,
                              method: :post, path: 'http://localhost/path', payload: {a: '1', b: '2'}) }

  subject { Dallal::Notifiers::ApiNotifier.new(notification) }

  describe 'notify!' do
    context 'when a custom client is defined' do
      let(:custom_client) { double('MyClient') }
      before { allow(subject.notification).to receive(:client).and_return(custom_client) }
      it 'initializes a the given client' do
        client_instance = double('MyClientInstance')
        expect(custom_client).to receive(:new).with(subject.notification).and_return(client_instance)
        expect(client_instance).to receive(:notify!)

        subject.notify!
      end
    end
    context 'when no custom client is defined' do
      before { allow(notification).to receive(:client) }

      it 'makes an http request to the given path with the given payload' do
        stub_request(:post, notification.path).
            with(:body => notification.payload).
            to_return(:status => 200, :body => "", :headers => {})
        subject.notify!
      end
    end
  end
end