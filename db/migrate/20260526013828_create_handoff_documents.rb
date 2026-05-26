class CreateHandoffDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :handoff_documents do |t|
      t.references :repository, null: false, foreign_key: true
      t.text :overview
      t.text :features
      t.text :database_notes
      t.text :environment_notes
      t.text :setup_notes
      t.text :operation_notes
      t.text :risks
      t.text :generated_markdown

      t.timestamps
    end
  end
end
