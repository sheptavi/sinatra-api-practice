require 'sinatra/base'
require 'sinatra/namespace'
require 'json'
require_relative 'database' # Подключаем настройки БД

module MyAppModule
  class App < Sinatra::Base
    register Sinatra::Namespace

    # Заставляем приложение всегда отвечать в формате JSON
    before do
      content_type 'application/json'
    end

    # Хелпер для преобразования массива объектов в JSON
    def collection_to_api(collection)
      collection.map { |item| item.to_api }.to_json
    end

    get '/' do
      { message: 'Hello My Sinatra - Easy and Wide world!' }.to_json
    end

    namespace '/api/v1' do
      # Получить список всех компаний
      get '/companies' do
        # Используем наш хелпер
        collection_to_api(Company.all)
      end

      # Получить список всех вакансий
      get '/jobs' do
        collection_to_api(Job.all)
      end
    end
  end
end