Rails.application.routes.draw do

  # require 'sidekiq/app'
  # mount Sidekiq::app => "/sidekiq"

  # Application Routes
  resources :applications, only: [:index, :create]
  get '/applications/:token', to: 'applications#show'
  get '/applications/:application_token/chats', to: 'applications#getChats'
  put '/applications/:token', to: 'applications#update'
  delete '/applications/:token', to: 'applications#destroy'

  # Chat Routes
  resources :chats, only: [:index]
  post '/chats/:application_token', to: 'chats#create'
  delete '/chats/:application_token/:chat_number', to: 'chats#destroy'
  get '/chats/:application_token/:chat_number/messages', to: 'chats#mgetMessages'

  # Message Routes
  resources :messages, only: [:index]
  post '/messages', to: 'messages#create'
  delete '/messages/:application_token/:chat_number/:message_number', to: 'messages#destroy'
  get '/messages/:application_token/:chat_number/:message_body/search', to: 'messages#search_in_message_body'

end
