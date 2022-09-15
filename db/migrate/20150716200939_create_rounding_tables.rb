class CreateRoundingTables < ActiveRecord::Migration
  def change
    create_table :rounding_tables do |t|
      t.string :api_code
      t.string :label
      t.string :description
      t.decimal :value

      t.timestamps
    end
  end
end
