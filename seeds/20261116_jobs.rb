Sequel.seed(:development, :test) do
  def run
    puts 'Seeding jobs'
    DB[:jobs].insert(name: 'Sinatra React', place: 'Remote', company_id: 1)
    DB[:jobs].insert(name: 'Ruby React', place: 'Contract', company_id: 2)
    DB[:jobs].insert(name: 'React', place: 'Remote', company_id: 3)
    DB[:jobs].insert(name: 'Ruby on Rails', place: 'Remote', company_id: 4)
  end
end