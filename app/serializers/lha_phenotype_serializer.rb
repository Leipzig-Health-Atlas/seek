class LhaPhenotypeSerializer < SimpleBaseSerializer

  attributes :title, :description, :datatype, :formula, :variables, :range, :score, :query, :index, :created_at, :updated_at

  belongs_to :phenotype_group
  belongs_to :lha_phenotype

end