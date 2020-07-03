class AddHumanDiseasesToDataFiles < ActiveRecord::Migration[5.2]
    def change
      create_table "data_files_human_diseases", id: false, force: :cascade do |t|
        t.integer "human_disease_id"
        t.integer "data_file_id"
      end
  
      add_index "data_files_human_diseases", ["human_disease_id", "data_file_id"], name: "index_diseases_data_files_on_disease_id_and_data_file_id", using: :btree
      add_index "data_files_human_diseases", ["data_file_id"], name: "index_diseases_data_files_on_data_file_id", using: :btree
    end
  end
