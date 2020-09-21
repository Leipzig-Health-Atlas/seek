class PhenotypeAlgorithmSerializer < SimpleBaseSerializer

  attributes :title, :description, :created_at, :updated_at

  has_many :phenotype_groups

end