class LhaPhenotype < ApplicationRecord

  scope :default_order, -> { order('index') }

  validates :id, presence: true, uniqueness: true
  validates :title, presence: true
  validates :phenotype_group_id, presence: true

  belongs_to :phenotype_group
  validates :phenotype_group, presence: true
  belongs_to :lha_phenotype

  has_many :lha_phenotypes, foreign_key:'lha_phenotype_id', dependent: :destroy

  searchable(auto_index: false) do
    text :id, :title, :description, :datatype
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

  def is_abstract?
    self.lha_phenotype ? false : true
  end

  def is_restricted?
    !self.is_abstract?
  end

  def data_portal_query
    if self.query and Seek::Config.lha_data_portal_param_name and Seek::Config.lha_data_portal_url
      params = {
        Seek::Config.lha_data_portal_param_name => self.query
      }
      "#{Seek::Config.lha_data_portal_url}?#{params.to_query}"
    end
  end

end