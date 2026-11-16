Sequel.migration do
  change do
    # Создаем таблицу соискателей (geeks), тr на нее ссылаются заявки
    create_table!(:geeks, :ignore_index_errors=>true) do
      primary_key :id
      String :name, :text=>true, :null => false
      String :stack, :text=>true, :null => false
      DateTime :created_at
      DateTime :updated_at
    end

    # Создаем таблицу заявок (applies)
    create_table!(:applies, :ignore_index_errors=>true) do
      primary_key :id
      foreign_key :job_id, :jobs, :null => false
      foreign_key :geek_id, :geeks, :null => false
      TrueClass :read, :default => false
      TrueClass :invited, :default => false
      DateTime :created_at
      DateTime :updated_at
    end
  end
end