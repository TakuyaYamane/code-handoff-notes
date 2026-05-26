class Repository < ApplicationRecord
  belongs_to :project
  has_one :handoff_document, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :url, presence: true
  validates :description, length: { maximum: 2_000 }

  validate :url_must_be_github_url

  def github_owner
    github_url_parts[0]
  end

  def github_repo
    github_url_parts[1]
  end

  private

  def github_url_parts
    url.delete_suffix(".git").split("github.com/").last.split("/")
  end

  def url_must_be_github_url
    return if url.blank?

    unless url.match?(/\Ahttps:\/\/github\.com\/[\w.-]+\/[\w.-]+(\.git)?\z/)
      errors.add(:url, "はGitHubリポジトリのURLを入力してください")
    end
  end
end