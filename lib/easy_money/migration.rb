MIGRATION_CLASS =
  if ActiveRecord::VERSION::MAJOR >= 5
    ActiveRecord::Migration["#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}"]
  else
    ActiveRecord::Migration
  end

class CreateCurrencies < MIGRATION_CLASS
  def change
    create_table :currencies do |t|
      t.jsonb :blob
      t.timestamps
    end
  end
end