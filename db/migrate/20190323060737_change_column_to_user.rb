class ChangeColumnToUser< ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :rememner_digest, :remember_digest
  end
end
