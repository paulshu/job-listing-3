# == Schema Information
#
# Table name: jobs
#
#  id               :integer          not null, primary key
#  title            :string
#  description      :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  wage_upper_bound :integer
#  wage_lower_bound :integer
#  contact_email    :string
#  city             :string
#  is_hidden        :boolean          default("t")
#

class Job < ApplicationRecord
  validates :title, presence: true
  validates :wage_upper_bound, presence: true
  validates :wage_lower_bound, presence: true
  validates :wage_lower_bound, numericality: { greater_than: 0}

  scope :published, -> { where(is_hidden: false) }
  #scope :currentU, -> { where(:user => current_user) } 调用不了
  scope :recent, -> { order('created_at DESC') }

  belongs_to :user #做收藏功能没有一定要加上这句。
  has_many :resumes
  has_many :job_favorites
  has_many :collectors, through: :job_favorites, source: :user

  def publish!
    self.is_hidden = false
    self.save
  end

  def hide!
    self.is_hidden = true
    self.save
  end


end
