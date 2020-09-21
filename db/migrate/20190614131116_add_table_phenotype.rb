class AddTablePhenotype < ActiveRecord::Migration
	def change
		create_table :phenotype_algorithms, id: :string, force: :cascade do |t|
			t.text     :title,       null: false
			t.text     :description
			t.datetime :created_at, null: false, default: Time.now
			t.datetime :updated_at, null: false, default: Time.now
		end

		create_table :phenotype_groups, id: :string, force: :cascade do |t|
			t.text       :title,       null: false
			t.text       :description
			t.integer    :index
			t.datetime   :created_at,  null: false, default: Time.now
			t.datetime   :updated_at,  null: false, default: Time.now
			t.belongs_to :phenotype_algorithm, type: :string, index: true, foreign_key: true, null: false
		end

		create_table :lha_phenotypes, id: :string, force: :cascade do |t|
			t.text       :title,       null: false
			t.text       :description
			t.string     :datatype,    limit: 50
			t.string     :formula,     limit: 300
			t.string     :variables,   limit: 300, array: true
			t.string     :range,       limit: 100
			t.decimal    :score
			t.text       :query
			t.integer    :index
			t.string     :unit,        null: true
			t.datetime   :created_at,  null: false, default: Time.now
			t.datetime   :updated_at,  null: false, default: Time.now
			t.belongs_to :lha_phenotype,   type: :string, index: true, foreign_key: true
			t.belongs_to :phenotype_group, type: :string, index: true, foreign_key: true, null: false
		end
	end
end