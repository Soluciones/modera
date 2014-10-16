# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :modera_banea_dominio, class: 'BaneaDominio' do
    dominio  { Faker::Internet.domain_name }

    factory :modera_banea_dominio_sin_extension, class: 'BaneaDominio' do
      dominio  { Faker::Internet.domain_word }
    end
  end
end
