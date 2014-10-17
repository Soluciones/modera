module Modera
  class BaneaDominio < ActiveRecord::Base
    NO_BANEABLES = %w(gmail yahoo hotmail outlook live.com telefonica movistar rankia)

    validates :dominio, presence: true, uniqueness: true
    validate :dominio_es_baneable

    before_validation { dominio.try(:downcase!) }

    def self.lista
      pluck(:dominio)
    end

    protected

    def dominio_es_baneable
      return if dominio.blank?

      if dominio_con_caracteres_invalidos?
        errors.add(:dominio, 'El dominio introducido tiene carácters inválidos')
      elsif dominio_es_un_sufijo?
        errors.add(:dominio, 'Los sufijos de dominio no se pueden banear')
      elsif dominio_listado_como_no_baneable?
        errors.add(:dominio, 'Este dominio no puede ser baneado')
      end
    end

    def dominio_es_un_sufijo?
      dominio =~ /\A\.?[a-z]{1,3}\z/i
    end

    def dominio_con_caracteres_invalidos?
      dominio =~ /[^a-z0-9\.-]/i
    end

    def dominio_listado_como_no_baneable?
      subdominio = '([a-z\-\d]+\.)'
      sufijo = '(\.[a-z]{2,3})'

      NO_BANEABLES.any? do |no_baneable|
        dominio =~ /\A#{ subdominio }*#{ no_baneable }#{ sufijo }{,2}\z/i
      end
    end
  end
end
