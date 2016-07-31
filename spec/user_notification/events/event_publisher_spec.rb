require 'rails_helper'

describe UserNotification::Events::EventPublisher do
  it { expect(subject).to be_a UserNotification::Events::Publisher }

  it { expect(subject.class.pub_sub_namespace).to eq 'user_notifications' }
end
