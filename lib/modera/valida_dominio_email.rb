require 'active_support/concern'

module Modera::ValidaDominioEmail
  extend ActiveSupport::Concern

  included { validate :email_con_dominio_permitido }

  def email_con_dominio_permitido
    return unless respond_to?(:email) && email.present?

    dominio = email.split('@').last
    if Modera::BaneaDominio.lista.include? dominio.downcase
      errors.add(:email, 'Este proveedor de correo electrónico no está permitido.')
    end
  end
end
