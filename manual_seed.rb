require_relative 'database'

puts "Очищаем базу"
DB[:jobs].truncate(cascade: true, restart: true)
DB[:companies].truncate(cascade: true, restart: true)

puts "Добавляем компании"
DB[:companies].insert(name: 'MoGo', location: 'New York')
DB[:companies].insert(name: 'Wirkkle', location: 'London')
DB[:companies].insert(name: 'Artesis', location: 'Saint-Petersburg')
DB[:companies].insert(name: 'BuildEmpire', location: 'London')

puts "Добавляем вакансии"
DB[:jobs].insert(name: 'Sinatra React', place: 'Remote', company_id: 1)
DB[:jobs].insert(name: 'Ruby React', place: 'Contract', company_id: 2)
DB[:jobs].insert(name: 'React', place: 'Remote', company_id: 3)
DB[:jobs].insert(name: 'Ruby on Rails', place: 'Remote', company_id: 4)

puts "Данные загружены."