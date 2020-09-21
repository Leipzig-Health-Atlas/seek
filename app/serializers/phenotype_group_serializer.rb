class PhenotypeGroupSerializer < SimpleBaseSerializer

  attributes :title, :description, :index, :created_at, :updated_at

  has_many :lha_phenotypes
  belongs_to :phenotype_algorithm

end