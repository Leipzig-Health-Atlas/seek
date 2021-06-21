class PhenotypeAlgorithm < ApplicationRecord
  include Seek::Search::CommonFields

  validates :id, presence: true, uniqueness: true
  validates :title, presence: true

  has_many :phenotype_groups, dependent: :destroy

  after_save { |phenotype_algorithm| Sunspot.index!(phenotype_algorithm) }

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