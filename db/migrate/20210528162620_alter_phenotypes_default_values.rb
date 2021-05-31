class AlterPhenotypesDefaultValues < ActiveRecord::Migration[5.2]
  def change
    change_column_default :phenotype_algorithms, :created_at, from: Time.now, to: -> { 'CURRENT_TIMESTAMP' }
    change_column_default :phenotype_algorithms, :updated_at, from: Time.now, to: -> { 'CURRENT_TIMESTAMP' }

    change_column_default :phenotype_groups, :created_at, from: Time.now, to: -> { 'CURRENT_TIMESTAMP' }
    change_column_default :phenotype_groups, :updated_at, from: Time.now, to: -> { 'CURRENT_TIMESTAMP' }

    change_column_default :lha_phenotypes, :created_at, from: Time.now, to: -> { 'CURRENT_TIMESTAMP' }
    change_column_default :lha_phenotypes, :updated_at, from: Time.now, to: -> { 'CURRENT_TIMESTAMP' }
  end
end
