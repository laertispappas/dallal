require 'rails_helper'

describe Dallal::Notifiers::HttpClient do
  let(:endpoint) { 'http://localhost' }
  subject { Dallal::Notifiers::HttpClient.new }

  context '#get' do
    it 'makes a get request' do
      stub_request(:get, "http://localhost/").
          to_return(:status => 200, :body => "", :headers => {})
      subject.get('/')
    end

    it 'makes a get request with query params' do
      stub_request(:get, "http://localhost/?a=1&b=2").
          to_return(:status => 200, :body => "", :headers => {})

      subject.get('/', a: 1, b: 2)
    end
  end

  context 'post'do
    it 'makes a post request' do
      stub_request(:post, "http://localhost/").
          to_return(:status => 200, :body => "", :headers => {})
      subject.post('/')
    end

    it 'makes a post request with a payload' do
      stub_request(:post, "http://localhost/").with(:body => {"a"=>"1", "b"=>"2"}).
          to_return(:status => 200, :body => "", :headers => {})

      subject.post('/', a: 1, b: 2)
    end
  end

  context 'put'do
    it 'makes a put request' do
      stub_request(:put, "http://localhost/").
          to_return(:status => 200, :body => "", :headers => {})
      subject.put('/')
    end

    it 'makes a post request with a payload' do
      stub_request(:put, "http://localhost/").with(:body => {"a"=>"1", "b"=>"2"}).
          to_return(:status => 200, :body => "", :headers => {})

      subject.put('/', a: 1, b: 2)
    end
  end
end