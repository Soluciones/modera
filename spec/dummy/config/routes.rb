Rails.application.routes.draw do

  resources :usuarios

  mount Modera::Engine => "/modera"
end
