class StudyType < ActiveRecord::Base

  validates_uniqueness_of :title
  validates_presence_of :title

  has_many :studies
end