# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :modera_banea_dominio, class: 'Modera::BaneaDominio' do
    dominio         { Faker::Internet.domain_name }
    updated_usuario { Faker::Internet.user_name }

    factory :modera_banea_dominio_sin_extension, class: 'Modera::BaneaDominio' do
      dominio         { Faker::Internet.domain_word }
    end
  end
end
