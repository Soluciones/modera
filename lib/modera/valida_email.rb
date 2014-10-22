require 'active_support/concern'

module Modera::ValidaEmail
  extend ActiveSupport::Concern

  # Para evitar problemas descritos en http://www.ruby-forum.com/topic/170101#747327
  EMAIL_FORMATO = /\A[A-Z0-9._%-]+@[A-Z0-9]+{2,}[A-Z0-9\-\.]*\z/i

  included do
    validates :email,
      uniqueness: { message: 'Ese correo electrónico ya está registrado.', case_sensitive: false },
      format: { with: EMAIL_FORMATO, message: 'Tienes que introducir un correo electrónico válido.' },
      length: { maximum: 50, message: 'El correo electrónico introducido es demasiado largo.' },
      confirmation: { message: 'El correo electrónico introducido no coincide con el de confirmación.' }
    validate :email_con_dominio_permitido
  end

  def email_con_dominio_permitido
    return unless respond_to?(:email) && email.present?

    dominio = email.split('@').last
    if Modera::BaneaDominio.lista.include? dominio.downcase
      errors.add(:email, 'Este proveedor de correo electrónico no está permitido.')
    end
  end
end
