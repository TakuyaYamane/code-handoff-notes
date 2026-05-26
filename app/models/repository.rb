class Repository < ApplicationRecord
  belongs_to :project
  has_one :handoff_document, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :url, presence: true
  validates :description, length: { maximum: 2_000 }

  validate :url_must_be_github_url

  private

  def url_must_be_github_url
    return if url.blank?

    unless url.match?(/\Ahttps:\/\/github\.com\/[\w.-]+\/[\w.-]+\z/)
      errors.add(:url, "must be a valid GitHub repository URL")
    end
  end
end