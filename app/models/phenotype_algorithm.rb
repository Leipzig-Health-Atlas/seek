class PhenotypeAlgorithm < ActiveRecord::Base
  include Seek::Search::BackgroundReindexing
  include Seek::Favouritable

  acts_as_favouritable

  scope :default_order, -> { order('title') }

  validates :id, presence: true, uniqueness: true
  validates :title, presence: true

  has_many :phenotype_groups, dependent: :destroy

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