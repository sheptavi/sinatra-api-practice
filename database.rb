require 'sequel'

# Подключаемся к нашей базе разработки
DB = Sequel.connect(
  adapter: :postgres,
  database: 'sinatra_seq_dev',
  host: 'localhost',
  password: 'password',
  user: 'sinatra_admin',
  max_connections: 10
)

# Модель компании
class Company < Sequel::Model
  one_to_many :jobs

  # Метод для правильного вывода в JSON
  def to_api
    { id: id, name: name, location: location }
  end
end

# Модель вакансии
class Job < Sequel::Model
  many_to_one :company

  # Метод для правильного вывода в JSON
  def to_api
    { id: id, name: name, place: place, company_id: company_id }
  end
end