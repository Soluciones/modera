class UsuariosController < InheritedResources::Base
  def permitted_params
    params.permit(usuario: [:email])
  end
end
