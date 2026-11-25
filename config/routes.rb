Rails.application.routes.draw do
  root "dashboard#index"

  resources :equipments do
  collection do
    get :monitoring
    get :calendar
  end
end

  
  resources :maintenances do
  collection do
    get :report
    get :export_pdf
  end
end
end