class AddVocabularyStudyTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :studies, :study_type_id, :integer

    create_table "study_types", force: :cascade do |t|
      t.string   "title",      limit: 255
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
