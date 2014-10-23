require 'rails_helper'

module Modera
  class DominioValidado
    include ActiveModel::Validations
    include Modera::ValidaDominioEmail

    attr_accessor :email
  end

  describe DominioValidado do
    describe 'validation test' do
      let(:error) { 'Este proveedor de correo electrónico no está permitido.' }

      context 'con un dominio baneado' do
        let(:dominio_baneado) { FactoryGirl.create(:modera_banea_dominio) }

        it 'no permite un email con el dominio baneado' do
          email_dominio_baneado = "usuario@#{ dominio_baneado.dominio }"
          is_expected.not_to allow_value(email_dominio_baneado).for(:email).with_message(error)
        end

        it 'permite un email cuyo dominio es subdominio del baneado' do
          email_subdominio_baneado = "usuario@subdominio.#{ dominio_baneado.dominio }"
          is_expected.to allow_value(email_subdominio_baneado).for(:email)
        end

        it 'permite un email cuyo dominio añade un sufijo al baneado' do
          email_dominio_baneado_con_sufijo = "usuario@#{ dominio_baneado.dominio }.com"
          is_expected.to allow_value(email_dominio_baneado_con_sufijo).for(:email)
        end

        it 'permite un email com dominio diferente al baneado' do
          email_dominio_permitido = Faker::Internet.email
          is_expected.to allow_value(email_dominio_permitido).for(:email)
        end
      end
    end
  end
end
