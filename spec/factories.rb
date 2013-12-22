FactoryGirl.define do
  factory :service_a, class: 'Service' do
    id 100
    name 'service a'
    url 'http://example.com'
  end
end

FactoryGirl.define do
  factory :codefirst_rule, class: 'ThumbnailRule' do
    regexp 'codefirst\.org/(.*)'
    thumbnail 'http://codefirst.org/$1.png'
  end

  factory :example_rule, class: 'ThumbnailRule' do
    regexp 'example\.com/(.*)'
    thumbnail 'http://example.com/$1.png'
  end
end
