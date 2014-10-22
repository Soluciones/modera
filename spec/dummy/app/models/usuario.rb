class Usuario < ActiveRecord::Base
  include Modera::ValidaDominioEmail
end
