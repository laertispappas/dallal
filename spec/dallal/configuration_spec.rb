require 'rails_helper'

describe Dallal::Configuration do
  subject do
    class DummClass
      extend Dallal::Configuration
    end

    DummClass
  end

  describe '.configure' do
    it 'returns the configuration when a block is given' do
      subject.configure do |config|
        expect(config).to be_a Dallal::Configuration::Configuration
      end
    end

    it { expect(subject.configure).to be nil }

    context "Configuration settings" do
      before do
        subject.configure do |config|
          config.user_class_name = 'UserClassName'
        end
      end

      it 'should have set confg attributes correctly' do
        expect(subject.configuration.user_class_name).to eq 'UserClassName'
      end
    end
  end

  describe '.options' do
    before do
      subject.configure do |config|
        config.user_class_name = 'UserClass'
      end
    end

    it 'should return all options' do
      expect(subject.options).to eq({
        user_class_name: 'UserClass',
        dallal_class_name: 'Dallal',
        enabled: true,
        email_layout: 'mailer',
        from_email: 'foo@bar.xyz',
        from_name: 'just a name',
        twilio_account_id: 'YOUR TWILIO ACCOUNT ID',
        twilio_auth_token: 'TWILIO_AUTH_TOKEN',
        sms_from: 'Sender phone number',
      })
    end
  end

  describe 'Default Config Values' do
    pending
  end
end
