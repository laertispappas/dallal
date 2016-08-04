require 'rails_helper'

describe Dallal do
  context "callbacks" do
    subject { FactoryGirl.build(:user) }
    it 'should broadcast a created event' do
      allow(subject).to receive(:id).and_return(1)

      expect(Dallal::Events::EventPublisher).to receive(:broadcast).
        with(class: subject.class.name, id: subject.id, event: :create).and_call_original

      subject.save!
    end
    it 'should broadcase an updated event' do
      subject.save

      expect(Dallal::Events::EventPublisher).to receive(:broadcast).
        with(class: subject.class.name, id: subject.id, event: :update).and_call_original

      subject.save!
    end
  end
end
