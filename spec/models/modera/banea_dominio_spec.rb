require 'rails_helper'

module Modera
  describe BaneaDominio do
    describe 'validation test' do
      let(:error_caracteres) { 'El dominio introducido tiene carácters inválidos' }
      let(:error_extension) { 'Las extensiones de dominio no se pueden banear' }
      let(:error_dominio) { 'Este dominio no puede ser baneado' }

      before { stub_const('Modera::BaneaDominio::NO_BANEABLES', %w(gmail yahoo.com)) }

      it { is_expected.to validate_presence_of(:dominio).with_message('Dominio no puede estar en blanco') }

      it { is_expected.not_to allow_value('gmail').for(:dominio).with_message(error_dominio) }
      it { is_expected.not_to allow_value('gmail.com').for(:dominio).with_message(error_dominio) }
      it { is_expected.not_to allow_value('gmail.com.mx').for(:dominio).with_message(error_dominio) }
      it { is_expected.not_to allow_value('subdominio.gmail').for(:dominio).with_message(error_dominio) }
      it { is_expected.not_to allow_value('subdominio.gmail.com').for(:dominio).with_message(error_dominio) }
      it { is_expected.not_to allow_value('subdominio.gmail.com.mx').for(:dominio).with_message(error_dominio) }

      it { is_expected.not_to allow_value('yahoo.com').for(:dominio).with_message(error_dominio) }
      it { is_expected.not_to allow_value('yahoo.com.mx').for(:dominio).with_message(error_dominio) }

      it { is_expected.not_to allow_value('.com').for(:dominio).with_message(error_extension) }
      it { is_expected.not_to allow_value('com').for(:dominio).with_message(error_extension) }
      it { is_expected.not_to allow_value('.es').for(:dominio).with_message(error_extension) }
      it { is_expected.not_to allow_value('es').for(:dominio).with_message(error_extension) }

      it { is_expected.not_to allow_value('@gmail.com').for(:dominio).with_message(error_caracteres) }
      it { is_expected.not_to allow_value('domin?o').for(:dominio).with_message(error_caracteres) }
      it { is_expected.not_to allow_value('dominio.c_om').for(:dominio).with_message(error_caracteres) }

      it { is_expected.to allow_value('dominio').for(:dominio) }
      it { is_expected.to allow_value('dominio.es').for(:dominio) }
      it { is_expected.to allow_value('subdominio.dominio.com').for(:dominio) }
      it { is_expected.to allow_value('sub-dominio1.subdominio2.dominio.com').for(:dominio) }
      it { is_expected.to allow_value('sub-dominio1.subdominio2.dominio').for(:dominio) }

      it { is_expected.to allow_value('gmai').for(:dominio) }
      it { is_expected.to allow_value('gmai.com').for(:dominio) }
      it { is_expected.to allow_value('gmail2').for(:dominio) }
      it { is_expected.to allow_value('gmail2.co.uk').for(:dominio) }
      it { is_expected.to allow_value('gmail.co.uk.mx').for(:dominio) }

      it { is_expected.to allow_value('yahoo').for(:dominio) }
      it { is_expected.to allow_value('yahoo.es').for(:dominio) }
      it { is_expected.to allow_value('yaho.com').for(:dominio) }
    end
  end
end

