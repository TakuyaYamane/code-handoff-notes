class HandoffDocument < ApplicationRecord
  belongs_to :repository

  validates :overview, presence: true
  validates :features, presence: true

  before_save :generate_markdown

  private

  def generate_markdown
    github_info = fetch_github_info

    self.generated_markdown = <<~MARKDOWN
      # #{repository.name} 引き継ぎドキュメント

      ## リポジトリ

      #{repository.url}

      ## プロジェクト

      #{repository.project.name}

      ## GitHub情報

      #{github_info_markdown(github_info)}

      ## システム概要

      #{overview}

      ## 主な機能

      #{features}

      ## データベース設計メモ

      #{database_notes.presence || "まだ記録されていません。"}

      ## 環境変数・設定

      #{environment_notes.presence || "まだ記録されていません。"}

      ## セットアップ手順

      #{setup_notes.presence || "まだ記録されていません。"}

      ## 運用メモ

      #{operation_notes.presence || "まだ記録されていません。"}

      ## リスク・引き継ぎ時の注意点

      #{risks.presence || "まだ記録されていません。"}

      ---

      このドキュメントは CodeHandoff Notes によって生成されました。
    MARKDOWN
  end

  def fetch_github_info
    GithubRepositoryFetcher.new(repository).call
  rescue StandardError => e
    {
      success: false,
      error: "#{e.class}: #{e.message}"
    }
  end

  def github_info_markdown(github_info)
    unless github_info[:success]
      return "GitHub情報を取得できませんでした。\n\n理由：#{github_info[:error]}"
    end

    <<~TEXT
      - 正式名：#{github_info[:full_name]}
      - 説明：#{github_info[:description].presence || "GitHub上の説明はありません。"}
      - 主な言語：#{github_info[:language].presence || "不明"}
      - スター数：#{github_info[:stars]}
      - デフォルトブランチ：#{github_info[:default_branch]}
      - 最終更新日時：#{github_info[:updated_at]}
      - GitHub URL：#{github_info[:html_url]}
    TEXT
  end
end