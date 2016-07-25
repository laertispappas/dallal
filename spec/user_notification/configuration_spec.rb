require 'rails_helper'

describe UserNotification::Configuration do
  subject do
    class DummClass
      extend UserNotification::Configuration
    end

    DummClass
  end

  describe '.configure' do
    it 'returns the configuration when a block is given' do
      subject.configure do |config|
        expect(config).to be_a UserNotification::Configuration::Configuration
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
        user_class_name: 'UserClass'
      })
    end
  end

  describe 'Default Config Values' do
    pending
  end
end
