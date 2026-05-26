class HandoffDocument < ApplicationRecord
  belongs_to :repository

  validates :overview, presence: true
  validates :features, presence: true

  before_save :generate_markdown

  private

  def generate_markdown
    self.generated_markdown = <<~MARKDOWN
      # #{repository.name} 引き継ぎドキュメント

      ## リポジトリ

      #{repository.url}

      ## プロジェクト

      #{repository.project.name}

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
end