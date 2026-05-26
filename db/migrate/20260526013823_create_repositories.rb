class CreateRepositories < ActiveRecord::Migration[8.1]
  def change
    create_table :repositories do |t|
      t.references :project, null: false, foreign_key: true
      t.string :name
      t.string :url
      t.text :description

      t.timestamps
    end
  end
end
