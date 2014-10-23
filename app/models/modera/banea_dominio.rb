module Modera
  class BaneaDominio < ActiveRecord::Base
    NO_BANEABLES = %w(gmail yahoo hotmail outlook live.com telefonica movistar rankia verema)

    default_scope { order(:dominio) }

    validates :dominio, presence: true, uniqueness: true
    validate :dominio_es_baneable

    before_validation { dominio.try(:downcase!) }

    protected

    def dominio_es_baneable
      if dominio_con_formato_incorrecto?
        errors.add(:dominio, 'El dominio introducido tiene un formato incorrecto')
      elsif dominio_listado_como_no_baneable?
        errors.add(:dominio, 'Este dominio no puede ser baneado')
      end
    end

    def dominio_con_formato_incorrecto?
      formato_dominio = '[a-z\d\-]+\.'
      formato_sufijo = '[a-z]+'

      dominio !~ /\A(#{ formato_dominio })+#{ formato_sufijo }\z/i
    end

    def dominio_listado_como_no_baneable?
      formato_subdominio = '[a-z\d\-]+\.'
      formato_sufijo = '\.[a-z]+'

      NO_BANEABLES.any? do |no_baneable|
        dominio =~ /\A(#{ formato_subdominio })*#{ no_baneable }(#{ formato_sufijo }){,2}\z/i
      end
    end
  end
end
