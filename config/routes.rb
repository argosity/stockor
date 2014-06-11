Skr::Workspace::Engine.routes.draw do
    root 'application#index'

    mount Skr::API::Root, at: "/api"

end
