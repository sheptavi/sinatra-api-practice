Sequel.seed(:development, :test) do
  def run
    puts 'Start truncate for all models'

    # truncate сбрасывает данные и возвращает ID счетчики на 1
    DB[:jobs].truncate(cascade: true, restart: true)
    DB[:companies].truncate(cascade: true, restart: true)
    puts 'Models truncated'
  end
end