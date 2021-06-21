class PhenotypeGroup < ApplicationRecord

  scope :default_order, -> { order('index') }

  validates :id, presence: true, uniqueness: true
  validates :title, presence: true
  validates :phenotype_algorithm_id, presence: true

  belongs_to :phenotype_algorithm
  validates :phenotype_algorithm, presence: true

  has_many :lha_phenotypes, dependent: :destroy

  searchable(auto_index: false) do
    text :id, :title, :description
  end if Seek::Config.solr_enabled

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