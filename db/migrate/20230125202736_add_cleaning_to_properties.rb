class AddCleaningToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :cleaning_fee, :decimal
  end
end
