class Usuario < ActiveRecord::Base
  include Modera::ValidaEmail
end
