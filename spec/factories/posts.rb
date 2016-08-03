FactoryGirl.define do
  factory :post, class: 'Post' do
    title 'A title'
    body 'some body'
    user
  end
end
