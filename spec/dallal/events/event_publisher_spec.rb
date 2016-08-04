require 'rails_helper'

describe Dallal::Events::EventPublisher do
  it { expect(subject).to be_a Dallal::Events::Publisher }

  it { expect(subject.class.pub_sub_namespace).to eq 'dallals' }
end
