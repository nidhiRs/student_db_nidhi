class AddColumnToStudents < ActiveRecord::Migration[6.0]
  def change
    add_column :students, :pending, :boolean, default: false
  end
end
