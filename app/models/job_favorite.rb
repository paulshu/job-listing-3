class JobFavorite < ApplicationRecord
  belongs_to :job
  belongs_to :user
end
