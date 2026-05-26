project = Project.find_or_create_by!(
  name: "【デモ】CodeHandoff Notes"
) do |p|
  p.description = "これはデモデータです。GitHubリポジトリの情報をもとに、ソフトウェア引き継ぎドキュメントを作成するRailsアプリの使用例です。"
end

repository = project.repositories.find_or_create_by!(
  url: "https://github.com/TakuyaYamane/code-handoff-notes"
) do |r|
  r.name = "【デモ】code-handoff-notes"
  r.description = "これはデモデータです。Ruby on Railsで作成した、引き継ぎドキュメント生成用ポートフォリオアプリのサンプルです。"
end

handoff_document = repository.handoff_document || repository.build_handoff_document

handoff_document.assign_attributes(
  overview: <<~TEXT.chomp,
    CodeHandoff Notesは、GitHubリポジトリの情報をもとに、ソフトウェアの引き継ぎドキュメントを作成するRailsアプリです。

    開発者がプロジェクト概要、リポジトリ情報、セットアップ手順、運用メモ、リスクなどを整理し、Markdown形式のドキュメントとして表示できます。

    ソフトウェア開発における「属人化」「引き継ぎ不足」「ドキュメント不足」という課題に対して、小さく実用的な解決策を作ることを目的としています。
  TEXT

  features: <<~TEXT.chomp,
    - プロジェクトの作成・表示・編集・削除
    - GitHubリポジトリの登録
    - GitHub APIからリポジトリ情報を取得
    - 引き継ぎドキュメントの作成・編集
    - Markdown形式でのドキュメント生成
    - 日本語UIによる操作
    - リポジトリ詳細画面でのGitHub情報表示
    - 生成ドキュメントへのGitHub情報反映
  TEXT

  database_notes: <<~TEXT.chomp,
    主なモデルは Project、Repository、HandoffDocument の3つです。

    Project は複数の Repository を持ちます。
    Repository は1つの Project に所属します。
    Repository は1つの HandoffDocument を持ちます。
    HandoffDocument は1つの Repository に所属します。

    この構成により、1つのソフトウェアプロジェクトに対して複数のリポジトリを登録し、それぞれに引き継ぎドキュメントを作成できます。
  TEXT

  environment_notes: <<~TEXT.chomp,
    開発環境では PostgreSQL を使用します。

    本番環境では DATABASE_URL が必要です。
    GitHub APIの利用制限を避けるため、必要に応じて GITHUB_TOKEN を設定します。

    今後AWSへデプロイする場合は、RDS、S3、アプリケーションサーバーに関連する環境変数を追加する予定です。
  TEXT

  setup_notes: <<~TEXT.chomp,
    1. GitHubからリポジトリをcloneする
    2. bundle install を実行する
    3. bin/rails db:create を実行する
    4. bin/rails db:migrate を実行する
    5. bin/rails db:seed を実行する
    6. bin/rails server で起動する
    7. ブラウザで http://localhost:3000 を開く
  TEXT

  operation_notes: <<~TEXT.chomp,
    現在はローカル開発環境で動作確認しています。

    GitHub API連携により、登録された公開リポジトリの正式名、説明、主な言語、スター数、デフォルトブランチ、最終更新日時を取得できます。

    今後はAWS上にデプロイし、PostgreSQLを本番DBとして利用する想定です。
  TEXT

  risks: <<~TEXT.chomp
    現時点では認証機能が未実装です。

    GitHub APIの取得情報は、公開リポジトリを前提としています。
    Privateリポジトリを扱う場合は、GitHub Tokenと権限管理が必要です。

    本番運用前には、認証、権限管理、エラーハンドリング、テスト、ログ管理を追加する必要があります。
  TEXT
)

handoff_document.save!

puts "Seed data created successfully."