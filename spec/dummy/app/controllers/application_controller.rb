class ApplicationController < ActionController::Base
  include ApplicationHelper, EmergiaHelper
  protect_from_forgery with: :exception

  before_filter :establece_usuario

  def gestor_usr_required
    unless soy_gestor_usr?
      envia_a_login('Debe identificarse como gestor de usuarios para acceder')
    end
  end

  def envia_a_login(_mensaje)
    true
  end

  protected

  def establece_usuario
    @yo ||= OpenStruct.new(nick: 'nick-usuario')
  end
end
