class PhenotypeGroup < ApplicationRecord
  validates :id, presence: true, uniqueness: true
  validates :title, presence: true
  validates :phenotype_algorithm_id, presence: true

  belongs_to :phenotype_algorithm
  validates :phenotype_algorithm, presence: true

  has_many :lha_phenotypes, dependent: :destroy

  def can_edit?(user = User.current_user)
    !user.nil? and user.is_admin?
  end

  def can_delete?(user = User.current_user)
    !user.nil? and user.is_admin?
  end

  def can_create?(user = User.current_user)
    !user.nil? and user.is_admin?
  end

end