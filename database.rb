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

  # Поиск по имени
  def self.by_name(name)
    where(Sequel.ilike(:name, "%#{name}%"))
  end

  # Поиск по локации через dataset_module
  dataset_module do
    def by_location(location)
      where(Sequel.ilike(:location, "%#{location}%"))
    end
  end
end


# Модель вакансии
class Job < Sequel::Model
  many_to_one :company

  # Метод для правильного вывода в JSON
  def to_api
    { id: id, name: name, place: place, company_id: company_id }
  end

  # Фильтры для вакансий
  def self.by_place(place)
    where(Sequel.ilike(:place, "%#{place}%"))
  end

  def self.by_company_name(company_name)
    company_ids = Company.where(Sequel.ilike(:name, "%#{company_name}%")).select_map(:id)
    where(company_id: company_ids)
  end
end

class Geek < Sequel::Model
  one_to_many :applies

  def to_api
    { id: id, name: name, stack: stack }
  end
end

class Apply < Sequel::Model
  many_to_one :job
  many_to_one :geek

  def to_api
    { id: id, read: read, invited: invited, job_id: job_id, geek_id: geek_id }
  end

  def self.read
    where(read: true)
  end

  def self.unread
    where(read: false)
  end
end
