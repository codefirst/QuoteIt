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

FactoryGirl.define do
  factory :html_rule_a, class: 'HtmlRule' do
    regexp 'codefirst\.org/(.*)'
    clip   'http://codefirst.org/$1.html'
    transform ''
  end

  factory :html_rule_b, class: 'HtmlRule' do
    regexp 'example\.com/(.*)'
    clip  'http://example.com/$1.html'
    transform ''
  end

  factory :html_rule_c, class: 'HtmlRule' do
    regexp 'json\.com/(.*)'
    clip 'http://example.com/$1.json'
    transform 'json["div"]'
  end
end
