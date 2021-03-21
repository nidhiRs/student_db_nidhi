class CreateStudents < ActiveRecord::Migration[6.0]
  def change
    create_table :students do |t|
      t.string :full_name
      t.text :address
      t.string :email
      t.references :institution, null: false, foreign_key: true

      t.timestamps
    end
  end
end
