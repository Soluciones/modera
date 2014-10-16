class Usuario < ActiveRecord::Base

  MAX_PRIVADOS_USR_NUEVO = 5
  # Valores de Usuario.nivel 0=Sin activar, 1=Usuario, 2=Moderador/Editor, 3=Administrador, 4=Gestor de usuarios, 5=Superadmin/Programador, -2=Baneado, -1=Desactivado.
  ESTADO_BANEADO = -2
  ESTADO_DESHABILITADO = -1
  ESTADO_SIN_ACTIVAR = 0
  ESTADO_NORMAL = 1
  ESTADO_MODERADOR = 2  # Tendrá permisos para editar sus contenidos por tiempo ilimitado, y podrá pasar mensajes a moderación. No puede ver contenidos borrados, ni editar directamente contenidos de otros.
  ESTADO_ADMIN = 3
  ESTADO_GESTOR_USR = 4
  ESTADO_SUPERADMIN = 5
  ESTADOS = [ESTADO_BANEADO, ESTADO_DESHABILITADO, ESTADO_SIN_ACTIVAR, ESTADO_NORMAL, ESTADO_MODERADOR, ESTADO_ADMIN, ESTADO_GESTOR_USR, ESTADO_SUPERADMIN]
end
