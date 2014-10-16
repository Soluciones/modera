class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper, EmergiaHelper

  def gestor_usr_required
    unless soy_gestor_usr?
      envia_a_login("Debe identificarse como gestor de usuarios para acceder")
    end
  end

  def envia_a_login(mensaje)
    true
  end
end
