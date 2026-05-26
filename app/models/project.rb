class Project < ApplicationRecord
  has_many :repositories, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 2_000 }
end