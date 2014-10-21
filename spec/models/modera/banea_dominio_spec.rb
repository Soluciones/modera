require 'rails_helper'

module Modera
  describe BaneaDominio do
    describe 'validation test' do
      let(:error_formato) { 'El dominio introducido tiene un formato incorrecto' }
      let(:error_dominio) { 'Este dominio no puede ser baneado' }

      before { stub_const('Modera::BaneaDominio::NO_BANEABLES', %w(gmail yahoo.com)) }

      it { is_expected.to validate_presence_of(:dominio).with_message('Dominio no puede estar en blanco') }

      %w(.com com .es es @gmail.com domin?o dominio.c_om gmai
         gmail2 gmail yahoo dominio domi_nio.es dominio.e1s)
      .each do |dominio|
        it { is_expected.not_to allow_value(dominio).for(:dominio).with_message(error_formato) }
      end

      %w(gmail.com gmail.com.mx subdominio.gmail subdominio.gmail.com
         subdominio.gmail.com.mx yahoo.com yahoo.com.mx)
      .each do |dominio|
        it { is_expected.not_to allow_value(dominio).for(:dominio).with_message(error_dominio) }
      end

      %w(gmai.com gmail2.co.uk gmail.co.uk.mx yahoo.es yaho.com domi-ni0.es dominio.es subdominio.dominio.com
         sub-dominio1.subdominio2.dominio.com sub-dominio1.subdominio2.dominio)
      .each do |dominio|
        it { is_expected.to allow_value(dominio).for(:dominio) }
      end
    end
  end
end
