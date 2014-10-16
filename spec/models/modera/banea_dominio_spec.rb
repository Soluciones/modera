require 'rails_helper'

module Modera
  describe BaneaDominio do
    describe 'validation test' do
      let(:error_extension) { 'Las extensiones de dominio no se pueden banear' }
      let(:error_dominio) { 'Este dominio no puede ser baneado' }

      it { is_expected.to validate_presence_of(:dominio).with_message('Dominio no puede estar en blanco') }
      it { is_expected.not_to allow_value('gmail').for(:dominio).with_message(error_dominio) }
      it { is_expected.not_to allow_value('gmail.com').for(:dominio).with_message(error_dominio) }
      it { is_expected.not_to allow_value('.com').for(:dominio).with_message(error_extension) }
      it { is_expected.not_to allow_value('com').for(:dominio).with_message(error_extension) }
      it { is_expected.not_to allow_value('.es').for(:dominio).with_message(error_extension) }
      it { is_expected.not_to allow_value('es').for(:dominio).with_message(error_extension) }
      it { is_expected.to allow_value('dominio').for(:dominio) }
      it { is_expected.to allow_value('dominio.es').for(:dominio) }
      it { is_expected.to allow_value('dominio.com').for(:dominio) }
    end
  end
end

