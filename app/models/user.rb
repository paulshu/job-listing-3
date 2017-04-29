# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  is_admin               :boolean          default("f")
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :resumes
  has_many :job_favorites
  has_many :favorite_jobs, through: :job_favorites, source: :job
  has_many :jobs

   def admin?
     is_admin
   end

   def is_favorite_of?(job)
     favorite_jobs.include?(job)
   end

   def favorite!(job)
     favorite_jobs << job
   end

   def unfavorite!(job)
     favorite_jobs.delete(job)
   end

   def display_name
     if self.name.present?
       self.name
     else
       self.email.split("@").first
     end
   end

end
