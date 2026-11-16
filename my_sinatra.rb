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
      # Принудительно делаем .all, если это Dataset, чтобы перебрать записи
      collection.all.map { |item| item.to_api }.to_json
    end

    get '/' do
      { message: 'Hello My Sinatra - Easy and Wide world!' }.to_json
    end

    namespace '/api/v1' do
      
      
      get '/companies' do
        # Начинаем с самого класса модели (это Dataset)
        companies = Company
        
        # Применяем фильтры, если они есть в запросе
        companies = companies.by_name(params['name']) if params['name']
        companies = companies.by_location(params['location']) if params['location']
        
        # Вызываем наш хелпер, который сделает .all и превратит в JSON
        collection_to_api(companies)
      end

      # Отображение одной компании
      get '/company/:id' do
        company = Company[params[:id].to_i]
        halt 404, { message: 'Company Not Found' }.to_json unless company
        # Используем to_api для правильного JSON
        company.to_api.to_json
      end

      # Создание компании
      post '/companies' do
        data = JSON.parse(request.body.read) rescue {}
        company = Company.create(name: data['name'], location: data['location'])
        status 201
        company.to_api.to_json
      end

      
      get '/jobs' do
        jobs = Job
        jobs = jobs.by_place(params['place']) if params['place']
        jobs = jobs.by_company_name(params['company']) if params['company']
        collection_to_api(jobs)
      end

      get '/job/:id' do
        job = Job[params[:id].to_i]
        halt 404, { message: 'Document Not Found', status: 404 }.to_json unless job
        job.to_api.to_json
      end

      # Прочитанные заявки
      get '/applies_read' do
        collection_to_api(Apply.read)
      end

      # Непрочитанные заявки
      get '/applies_unread' do
        collection_to_api(Apply.unread)
      end

      # Все вакансии конкретной компании по имени
      get '/jobs_company/:name' do
        company = Company.where(Sequel.ilike(:name, "%#{params[:name]}%")).first
        halt 404, { message: 'Company Not Found' }.to_json unless company
        
        jobs = Job.where(company_id: company.id)
        halt 404, { message: 'Documents Not Found' }.to_json if jobs.empty?
        
        collection_to_api(jobs)
      end

      # Все вакансии конкретной компании через query-параметр
      get '/company_jobs' do
        company = Company.where(Sequel.ilike(:name, "%#{params[:name]}%")).first
        if company
          collection_to_api(Job.where(company_id: company.id))
        else
          [].to_json
        end
      end

    end
  end
end