module Modera
  class BaneaDominiosController < InheritedResources::Base
    before_filter :gestor_usr_required

    def create
      @banea_dominio = BaneaDominio.new(dominio: params[:banea_dominio][:dominio],
                                        updated_usuario: @yo.nick)
      create! { banea_dominios_path }
    end

    def update
      @banea_dominio = BaneaDominio.find(params[:id])
      @banea_dominio.updated_usuario = @yo.nick
      update! { banea_dominios_path }
    end

    protected

    def permitted_params
      params.permit(banea_dominio: [:dominio])
    end

    def collection
      @banea_dominios ||= end_of_association_chain.order(:dominio)
    end
  end
end
