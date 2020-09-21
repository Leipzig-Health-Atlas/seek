class PhenotypeAlgorithmsSweeper < ActionController::Caching::Sweeper
  include CommonSweepers

  observe PhenotypeAlgorithm

  def after_create(_o)
    expire_phenotype_algorithm_gadget
  end

  def after_update(_o)
    expire_phenotype_algorithm_gadget
  end

  def after_destroy(_o)
    expire_phenotype_algorithm_gadget
  end
end