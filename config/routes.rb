Rails.application.routes.draw do
  post 'profile_data', to: 'profiles#create'
  
  patch 'profile_data/:id', to: 'profiles#update'
end
