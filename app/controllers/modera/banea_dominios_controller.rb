module Modera
  class BaneaDominiosController < InheritedResources::Base
    before_filter :gestor_usr_required

    def create
      create! { banea_dominios_path }
    end

    def update
      update! { banea_dominios_path }
    end

    def permitted_params
      params.permit(banea_dominio: [:dominio])
    end
  end
end
