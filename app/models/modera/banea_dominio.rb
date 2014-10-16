module Modera
  class BaneaDominio < ActiveRecord::Base
    NO_BANEABLES = %w(gmail yahoo hotmail)

    validates :dominio, presence: true, uniqueness: true
    validate :es_baneable

    before_validation { dominio.try(:downcase!) }

    def es_baneable
      return if dominio.blank?
      formato_extension = /\A\.?[a-z]{1,3}\z/

      if dominio =~ formato_extension
        errors.add(:dominio, 'Las extensiones de dominio no se pueden banear')
      elsif NO_BANEABLES.any? { |no_baneable| dominio.include?(no_baneable) || no_baneable.include?(dominio) }
        errors.add(:dominio, 'Este dominio no puede ser baneado')
      end
    end

    def self.lista
      pluck(:dominio)
    end
  end
end
